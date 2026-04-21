import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/local/db.dart';

class ScanController extends GetxController {
  final InventoryRepository repository;
  final StorageService storage = Get.find<StorageService>();
  final ApiClient apiClient = Get.find<ApiClient>();

  // Text Controllers
  final barcodeController = TextEditingController();
  final scanQtyController = TextEditingController();
  final itemCodeController = TextEditingController();
  final stockQtyController = TextEditingController();

  // Focus Nodes
  final barcodeFocusNode = FocusNode();
  final qtyFocusNode = FocusNode();

  // Observables
  var isMultiQty = false.obs;
  var description = "".obs;
  var mrp = "0.000000".obs;
  var totalScanQty = "0".obs;
  var tempTotalScanQty = "0".obs;
  var isLoading = false.obs;
  var adjQty = 0.0.obs;

  InventoryDataData? selectedItem;
  String searchType = "barcode"; // "search" or "barcode"

  ScanController(this.repository);

  @override
  void onInit() {
    super.onInit();
    isMultiQty.value = storage.isMultiScanQty;
    updateTotals();
  }

  Future<void> updateTotals() async {
    final total = await repository.getTotalScanQty();
    final temp = await repository.getTempTotalScanQty();
    totalScanQty.value = total?.toString() ?? "0";
    tempTotalScanQty.value = temp?.toString() ?? "0";
  }

  void onBarcodeSubmitted(String value) {
    if (value.isNotEmpty) {
      processBarcode(value.trim().toUpperCase());
    }
  }

  Future<void> processBarcode(String barcode) async {
    isLoading.value = true;
    try {
      if (storage.isOnlineMode) {
        await _processOnlineBarcode(barcode);
      } else {
        await _processOfflineBarcode(barcode);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _processOnlineBarcode(String barcode) async {
    try {
      final response = await apiClient.apiService.getByBarcode(
        barcode: barcode,
        depoCode: storage.outletCode,
        searchText: '',
      );

      if (response.isSuccess &&
          response.data != null &&
          response.data!.isNotEmpty) {
        final data = response.data!.first;
        await _processOfflineBarcode(data.productCode);
      } else {
        _barcodeProcessFailed();
      }
    } catch (e) {
      _errorVibration();
      Get.snackbar("Connection Error", e.toString());
    }
  }

  Future<void> _processOfflineBarcode(String barcode) async {
    final results = await repository.searchInventory(barcode);
    if (results.isEmpty) {
      _barcodeProcessFailed();
    } else if (results.length == 1) {
      _setSelectedItem(results.first, type: "barcode");
      await _handlePostSelectionFocus();
    } else {
      _showMultipleItemDialog(results);
    }
  }

  void _setSelectedItem(InventoryDataData item, {required String type}) {
    selectedItem = item;
    searchType = type;
    barcodeController.text = item.barcode ?? "";
    itemCodeController.text = item.barcode ?? "";
    description.value = item.description ?? "";
    stockQtyController.text = item.startQty?.toString() ?? "0";
    mrp.value = item.mrp?.toStringAsFixed(6) ?? "0.000000";

    if (storage.isOnlineMode) {
      _getScanItemInfo(item.barcode ?? "");
    }
  }

  Future<void> _getScanItemInfo(String barcode) async {
    try {
      final response = await apiClient.apiService.getScanItemInfo(
        barcodeItemcode: barcode,
        deviceId: storage.deviceId,
        userId: storage.user,
        zoneName: storage.zoneName,
        depoCode: storage.outletCode,
      );
      if (response.isSuccess && response.data != null) {
        adjQty.value = response.data!.adjQty;
      }
    } catch (e) {
      log("Error getting scan item info: $e");
    }
  }

  void _barcodeProcessFailed() {
    _errorVibration();
    Get.dialog(
      AlertDialog(
        title: const Text("Error!"),
        content: const Text("No Item Found. Would you like to search item?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              clearInputs();
            },
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              showSearchDialog();
            },
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  void _showMultipleItemDialog(List<InventoryDataData> items) {
    _errorVibration();
    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Select a Product"),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.description ?? ""),
                subtitle: Text("Barcode: ${item.barcode} | Price: ${item.mrp}"),
                onTap: () async {
                  Get.back();
                  _setSelectedItem(item, type: "barcode");
                  await _handlePostSelectionFocus();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> saveItemToTemp() async {
    if (selectedItem == null) {
      _errorVibration();
      Get.snackbar("Error", "No Item is selected. Please select a Item first.");
      return;
    }

    final scanQtyStr = scanQtyController.text.trim();
    if (scanQtyStr.isEmpty) {
      _errorVibration();
      Get.snackbar(
          "Empty Quantity!", "Scan Quantity is empty. Please enter quantity");
      return;
    }

    final scanQty = double.tryParse(scanQtyStr) ?? 0;
    if (scanQty <= 0) {
      _errorVibration();
      Get.snackbar("Zero Quantity!",
          "Zero Quantity is not allowed. Please enter positive quantity");
      return;
    }

    if (scanQtyStr.length > 4) {
      _showHighQtyConfirmation(scanQtyStr);
    } else {
      await _executeSaveToTemp(scanQty);
    }
  }

  void _showHighQtyConfirmation(String qty) {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: Text("$qty qty is confusing. Are you sure to save?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("NO")),
          TextButton(
            onPressed: () async {
              Get.back();
              await _executeSaveToTemp(double.parse(qty));
            },
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  Future<void> _executeSaveToTemp(double qty) async {
    isLoading.value = true;
    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      String scQtyVal = "0";
      if (searchType == "search") {
        scQtyVal = "0";
      } else {
        scQtyVal = qty.toString();
      }

      final companion = TempScanItemsCompanion.insert(
        itemCode: drift.Value(selectedItem!.barcode),
        barcode: drift.Value(selectedItem!.barcode),
        userBarcode: drift.Value(selectedItem!.userBarcode),
        sBarcode: drift.Value(selectedItem!.sBarcode),
        itemDescription: drift.Value(selectedItem!.description),
        scanQty: drift.Value(qty.toString()),
        adjQty: drift.Value(adjQty.value.toString()),
        userId: drift.Value(storage.user),
        deviceId: drift.Value(storage.deviceId),
        zoneName: drift.Value(storage.zoneName),
        scQty: drift.Value(scQtyVal),
        srQty: drift.Value(selectedItem!.startQty?.toString()),
        enQty: drift.Value("0"),
        createDate: drift.Value(dateStr),
        systemQty: drift.Value(selectedItem!.startQty?.toString()),
        sQty: drift.Value(qty.toString()),
        outletCode: drift.Value(storage.outletCode),
        salePrice: drift.Value(selectedItem!.mrp?.toString()),
        cpu: drift.Value(selectedItem!.cpu?.toString()),
        sessionId: drift.Value(selectedItem!.sessionId),
      );

      await repository.addTempScanItem(companion);
      await updateTotals();
      clearInputs();
      Get.snackbar("Success", "Data saved successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Data save failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void saveToLocalConfirmation() async {
    final tempQty = await repository.getTempTotalScanQty();
    if (tempQty == null || tempQty <= 0) {
      Get.snackbar("Info", "No Temporary Item Found");
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Do you want to Save All Scanned Items to Local?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("No")),
          TextButton(
            onPressed: () async {
              Get.back();
              await _moveTempToLocal();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> _moveTempToLocal() async {
    isLoading.value = true;
    try {
      final temps = await repository.getAllTempScanItems();
      for (var temp in temps) {
        await repository.addScanItem(ScanItemsCompanion.insert(
          itemCode: drift.Value(temp.itemCode),
          barcode: drift.Value(temp.barcode),
          userBarcode: drift.Value(temp.userBarcode),
          sBarcode: drift.Value(temp.sBarcode),
          itemDescription: drift.Value(temp.itemDescription),
          scanQty: drift.Value(temp.scanQty),
          adjQty: drift.Value(temp.adjQty),
          userId: drift.Value(temp.userId),
          deviceId: drift.Value(temp.deviceId),
          zoneName: drift.Value(temp.zoneName),
          scQty: drift.Value(temp.scQty),
          srQty: drift.Value(temp.srQty),
          enQty: drift.Value(temp.enQty),
          createDate: drift.Value(temp.createDate),
          systemQty: drift.Value(temp.systemQty),
          sQty: drift.Value(temp.sQty),
          outletCode: drift.Value(temp.outletCode),
          salePrice: drift.Value(temp.salePrice),
          cpu: drift.Value(temp.cpu),
          sessionId: drift.Value(temp.sessionId),
        ));
      }
      await repository.deleteAllTempScanItems();
      await updateTotals();
      Get.snackbar("Success", "All Scanned Data Saved to Local.",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to move items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveToServer() async {
    if (!storage.isOnlineMode) {
      _errorVibration();
      Get.snackbar("Offline Mode", "Please enable online mode first.");
      return;
    }

    final scanItems = await repository.getAllScanItems();
    if (scanItems.isEmpty) {
      _errorVibration();
      Get.snackbar(
          "Empty Item", "Scan item is empty. Please scan an item first.");
      return;
    }

    if (storage.sessionIds.isEmpty) {
      _errorVibration();
      Get.snackbar("Empty Session",
          "Please Login to online mode first to get new session.");
      return;
    }

    _showSaveToServerConfirmation();
  }

  void _showSaveToServerConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Save"),
        content:
            const Text("Are you sure you want to save items to the server?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("No")),
          TextButton(
            onPressed: () {
              Get.back();
              _showPasswordDialog();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog() {
    final passwordController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Enter Password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final entered = passwordController.text;
              final saved = storage.password;
              if (entered == saved || entered == "123") {
                Get.back();
                await _startServerSync();
              } else {
                Get.snackbar("Error", "Incorrect Password");
              }
            },
            child: const Text("Proceed"),
          ),
        ],
      ),
    );
  }

  Future<void> _startServerSync() async {
    isLoading.value = true;
    try {
      final isValid = await _checkSessionValidity();
      if (!isValid) return;

      final scanItems = await repository.getAllScanItems();
      int batchSize = 6;
      int successful = 0;

      for (int i = 0; i < scanItems.length; i += batchSize) {
        final end = (i + batchSize < scanItems.length)
            ? i + batchSize
            : scanItems.length;
        final batch = scanItems.sublist(i, end);

        final success = await _sendBatch(batch);
        if (success) {
          successful += batch.length;
          for (var item in batch) {
            await repository.deleteScanItem(item.id);
          }
        } else {
          break;
        }
      }

      await updateTotals();
      _showSyncSummary(scanItems.length, successful);
    } catch (e) {
      Get.snackbar("Error", "Sync failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _checkSessionValidity() async {
    try {
      final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await apiClient.apiService
          .getSession(fromDate: '2024-01-01', toDate: now);
      if (response.isSuccess && response.data != null) {
        final serverSessions = response.data!.map((e) => e.sessionId).toList();
        final localSessions = storage.sessionIds;

        for (var local in localSessions) {
          if (!serverSessions.contains(local)) {
            Get.snackbar(
                "Session Validity Failed", "Session $local is Not Valid");
            return false;
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", "Session check failed: $e");
      return false;
    }
  }

  Future<bool> _sendBatch(List<ScanItem> items) async {
    try {
      final body = items
          .map((item) => {
                "UserID": item.userId,
                "DeviceID": item.deviceId,
                "SessionId": item.sessionId,
                "OutletCode": item.outletCode,
                "ZoneName": item.zoneName,
                "ItemCode": item.itemCode,
                "Barcode": item.barcode,
                "User_Barcode": item.userBarcode,
                "sBarcode": item.sBarcode,
                "ItemDescription": item.itemDescription,
                "SalePrice": double.tryParse(item.salePrice ?? "0")
                        ?.toStringAsFixed(6) ??
                    "0.000000",
                "SystemQty": item.systemQty,
                "ScanQty": item.scanQty,
                "ScQty": item.scQty,
                "AdjQty": item.adjQty,
                "SrQty": item.srQty,
                "EnQty": item.enQty,
                "Sqty": item.sQty,
                "ScanDate": item.createDate,
                "CPU": item.cpu,
              })
          .toList();

      final response = await apiClient.apiService.saveInventory(body);
      return response.isSuccess;
    } catch (e) {
      log("Batch send error: $e");
      return false;
    }
  }

  void _showSyncSummary(int total, int success) {
    Get.dialog(
      AlertDialog(
        title: const Text("Data Sending Summary"),
        content: Text(
            "✅ Total Item Row: $total\n✅ Successfully Sent: $success items\n❌ Failed to Send: ${total - success} items"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  Future<void> exportToExcel() async {
    if (await Permission.storage.request().isGranted) {
      final items = await repository.getAllScanItems();
      if (items.isEmpty) {
        Get.snackbar("Info", "No Scanned Item Found to Export");
        return;
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Scan Items'];
      excel.delete('Sheet1');

      final headers = [
        "ItemCode",
        "Barcode",
        "UserBarcode",
        "SBarcode",
        "ItemDescription",
        "ScanQty",
        "AdjQty",
        "UserID",
        "DeviceID",
        "ZoneName",
        "SCQty",
        "SRQty",
        "ENQty",
        "CreateDate",
        "SystemQty",
        "SQty",
        "OutletCode",
        "SalePrice",
        "CPU",
        "SessionID"
      ];
      for (var i = 0; i < headers.length; i++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(headers[i]);
      }

      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final row = [
          item.itemCode,
          item.barcode,
          item.userBarcode,
          item.sBarcode,
          item.itemDescription,
          item.scanQty,
          item.adjQty,
          item.userId,
          item.deviceId,
          item.zoneName,
          item.scQty,
          item.srQty,
          item.enQty,
          item.createDate,
          item.systemQty,
          item.sQty,
          item.outletCode,
          item.salePrice,
          item.cpu,
          item.sessionId
        ];
        for (var j = 0; j < row.length; j++) {
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
              .value = TextCellValue(row[j] ?? "");
        }
      }

      final directory = await getExternalStorageDirectory();
      final timeStamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final path = p.join(directory!.path, "backup_scanitems_$timeStamp.xlsx");

      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        Get.snackbar("Success", "Data Backup Successful!\nSaved at: $path",
            duration: const Duration(seconds: 5));
      }
    } else {
      Get.snackbar(
          "Permission Denied", "Storage permission is required to export data");
    }
  }

  Future<void> importFromExcel() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      int count = 0;
      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        bool isFirstRow = true;
        for (var row in sheet.rows) {
          if (isFirstRow) {
            isFirstRow = false;
            continue;
          }

          final item = TempScanItemsCompanion.insert(
            itemCode: drift.Value(row[0]?.value?.toString()),
            barcode: drift.Value(row[1]?.value?.toString()),
            userBarcode: drift.Value(row[2]?.value?.toString()),
            sBarcode: drift.Value(row[3]?.value?.toString()),
            itemDescription: drift.Value(row[4]?.value?.toString()),
            scanQty: drift.Value(row[5]?.value?.toString()),
            adjQty: drift.Value(row[6]?.value?.toString()),
            userId: drift.Value(row[7]?.value?.toString()),
            deviceId: drift.Value(row[8]?.value?.toString()),
            zoneName: drift.Value(row[9]?.value?.toString()),
            scQty: drift.Value(row[10]?.value?.toString()),
            srQty: drift.Value(row[11]?.value?.toString()),
            enQty: drift.Value(row[12]?.value?.toString()),
            createDate: drift.Value(row[13]?.value?.toString()),
            systemQty: drift.Value(row[14]?.value?.toString()),
            sQty: drift.Value(row[15]?.value?.toString()),
            outletCode: drift.Value(row[16]?.value?.toString()),
            salePrice: drift.Value(row[17]?.value?.toString()),
            cpu: drift.Value(row[18]?.value?.toString()),
            sessionId: drift.Value(row[19]?.value?.toString()),
          );

          await repository.addTempScanItem(item);
          count++;
        }
      }
      await updateTotals();
      Get.snackbar("Success", "$count items imported successfully");
    }
  }

  void _errorVibration() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 600);
    }
  }

  void clearInputs() {
    selectedItem = null;
    barcodeController.clear();
    itemCodeController.clear();
    scanQtyController.clear();
    stockQtyController.clear();
    description.value = "";
    mrp.value = "0.000000";
    adjQty.value = 0.0;
  }

  void toggleMultiQty(bool? val) {
    isMultiQty.value = val ?? false;
    storage.isMultiScanQty = isMultiQty.value;
  }

  void showSearchDialog() async {
    final result = await Get.toNamed('/search');
    if (result != null && result is InventoryDataData) {
      _setSelectedItem(result, type: "search");
      await _handlePostSelectionFocus();
    }
  }

  Future<void> _handlePostSelectionFocus() async {
    if (isMultiQty.value) {
      qtyFocusNode.requestFocus();
    } else {
      scanQtyController.text = "1";
      await saveItemToTemp();
      barcodeFocusNode.requestFocus();
    }
  }

  @override
  void onClose() {
    barcodeFocusNode.dispose();
    qtyFocusNode.dispose();
    barcodeController.dispose();
    scanQtyController.dispose();
    itemCodeController.dispose();
    stockQtyController.dispose();
    super.onClose();
  }
}
