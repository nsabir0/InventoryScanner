import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/local/db.dart';

class ScanController extends GetxController {
  final InventoryRepository repository;
  final StorageService storage = Get.find<StorageService>();
  final ApiClient apiClient = Get.find<ApiClient>();

  final barcodeController = TextEditingController();
  final scanQtyController = TextEditingController();
  final itemCodeController = TextEditingController();
  final stockQtyController = TextEditingController();

  var isMultiQty = true.obs;
  var description = "".obs;
  var mrp = "0.00".obs;
  var totalScanQty = "0".obs;
  var tempTotalScanQty = "0".obs;
  var isLoading = false.obs;

  InventoryDataData? selectedItem;

  ScanController(this.repository);

  @override
  void onInit() {
    super.onInit();
    isMultiQty.value =
        true; // Default as per native chkScanMultiQty.setChecked(pref.isMultiScanQty());
    updateTotals();
  }

  Future<void> updateTotals() async {
    final total = await repository.getTotalScanQty();
    final temp = await repository.getTempTotalScanQty();
    totalScanQty.value = total?.toStringAsFixed(2) ?? "0";
    tempTotalScanQty.value = temp?.toStringAsFixed(2) ?? "0";
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

      if (response.isSuccess && response.data != null && response.data!.isNotEmpty) {
        final data = response.data!.first;
        // In native, it calls barcodeProcessForOffline(itemCode) after online fetch
        await _processOfflineBarcode(data.productCode);
      } else {
        Get.snackbar("Error", "No Item Found");
      }
    } catch (e) {
      Get.snackbar("Error", "Online search failed: $e");
    }
  }

  Future<void> _processOfflineBarcode(String barcode) async {
    final results = await repository.searchInventory(barcode);
    if (results.isEmpty) {
      Get.snackbar("Error", "No Item Found Offline");
    } else if (results.length == 1) {
      _setSelectedItem(results.first);
      if (!isMultiQty.value) {
        scanQtyController.text = "1";
        saveItem();
      }
    } else {
      // Show selection dialog
      _showItemSelectionDialog(results);
    }
  }

  void _setSelectedItem(InventoryDataData item) {
    selectedItem = item;
    barcodeController.text = item.barcode ?? "";
    itemCodeController.text = item.barcode ?? "";
    description.value = item.description ?? "";
    stockQtyController.text = item.startQty?.toString() ?? "0";
    mrp.value = item.mrp?.toStringAsFixed(6) ?? "0.000000";
  }

  void _showItemSelectionDialog(List<InventoryDataData> items) {
    Get.dialog(
      AlertDialog(
        title: const Text("Select a Product"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.description ?? ""),
                subtitle: Text("Price: ${item.mrp}"),
                onTap: () {
                  _setSelectedItem(item);
                  Get.back();
                  if (!isMultiQty.value) {
                    scanQtyController.text = "1";
                    saveItem();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> saveItem() async {
    if (selectedItem == null) {
      Get.snackbar("Error", "No item selected");
      return;
    }

    final qtyStr = scanQtyController.text.trim();
    if (qtyStr.isEmpty ||
        double.tryParse(qtyStr) == null ||
        double.parse(qtyStr) <= 0) {
      Get.snackbar("Error", "Invalid Quantity");
      return;
    }

    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final companion = TempScanItemsCompanion.insert(
      barcode: drift.Value(selectedItem!.barcode),
      userBarcode: drift.Value(selectedItem!.userBarcode),
      sBarcode: drift.Value(selectedItem!.sBarcode),
      itemDescription: drift.Value(selectedItem!.description),
      scanQty: drift.Value(qtyStr),
      userId: drift.Value(storage.user),
      deviceId: drift.Value(storage.deviceId),
      zoneName: drift.Value(storage.zoneName),
      scQty: drift.Value(qtyStr),
      srQty: drift.Value(selectedItem!.startQty?.toString()),
      createDate: drift.Value(dateStr),
      systemQty: drift.Value(selectedItem!.startQty?.toString()),
      outletCode: drift.Value(storage.outletCode),
      salePrice: drift.Value(selectedItem!.mrp?.toString()),
      cpu: drift.Value(selectedItem!.cpu?.toString()),
      sessionId: drift.Value(selectedItem!.sessionId),
    );

    await repository.addTempScanItem(companion);
    await updateTotals();
    clearInputs();
    Get.snackbar("Success", "Item saved successfully",
        snackPosition: SnackPosition.BOTTOM);
  }

  void clearInputs() {
    selectedItem = null;
    barcodeController.clear();
    itemCodeController.clear();
    scanQtyController.clear();
    stockQtyController.clear();
    description.value = "";
    mrp.value = "0.00";
  }

  Future<void> saveToLocal() async {
    // Logic to move from TempScanItems to ScanItems
    // In native: DB.saveTempScanItemsToLocal();
    // This is a batch process.
    final temps = await repository.getAllTempScanItems();
    if (temps.isEmpty) return;

    for (var temp in temps) {
      await repository.addScanItem(ScanItemsCompanion.insert(
        itemCode: drift.Value(temp.itemCode),
        barcode: drift.Value(temp.barcode),
        userBarcode: drift.Value(temp.userBarcode),
        sBarcode: drift.Value(temp.sBarcode),
        itemDescription: drift.Value(temp.itemDescription),
        scanQty: drift.Value(temp.scanQty),
        userId: drift.Value(temp.userId),
        deviceId: drift.Value(temp.deviceId),
        zoneName: drift.Value(temp.zoneName),
        scQty: drift.Value(temp.scQty),
        srQty: drift.Value(temp.srQty),
        createDate: drift.Value(temp.createDate),
        systemQty: drift.Value(temp.systemQty),
        outletCode: drift.Value(temp.outletCode),
        salePrice: drift.Value(temp.salePrice),
        cpu: drift.Value(temp.cpu),
        sessionId: drift.Value(temp.sessionId),
      ));
    }
    await repository.deleteAllTempScanItems();
    await updateTotals();
    Get.snackbar("Success", "All temporary items saved to local");
  }
}
