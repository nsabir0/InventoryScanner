import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/local/db.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class AdjustController extends GetxController {
  final InventoryRepository repository;
  final StorageService storage;

  AdjustController(this.repository, this.storage);

  final barcodeController = TextEditingController();
  final adjustQtyController = TextEditingController();
  final barcodeFocusNode = FocusNode();
  final adjustQtyFocusNode = FocusNode();

  var itemCode = "".obs;
  var stockQty = "".obs;
  var scanQty = "".obs;
  var adjustedQty = "".obs;

  InventoryDataData? currentItem;
  ScanItem? currentScanItem;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      barcodeFocusNode.requestFocus();
    });
  }

  @override
  void onClose() {
    barcodeController.dispose();
    adjustQtyController.dispose();
    barcodeFocusNode.dispose();
    adjustQtyFocusNode.dispose();
    super.onClose();
  }

  void errorVibration() {
    Vibration.vibrate(duration: 600);
  }

  void clearInputs() {
    barcodeController.clear();
    adjustQtyController.clear();
    itemCode.value = "";
    stockQty.value = "";
    scanQty.value = "";
    adjustedQty.value = "";
    currentItem = null;
    currentScanItem = null;
    barcodeFocusNode.requestFocus();
  }

  void onBarcodeSubmitted(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return;

    final items = await repository.getInventoryItemByBarcode(code);

    if (items.length > 1) {
      errorVibration();
      _showMultipleItemsDialog(items);
    } else if (items.length == 1) {
      _updateLayout(items[0]);
    } else {
      _barcodeProcessFailed();
    }
  }

  void _showMultipleItemsDialog(List<InventoryDataData> items) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select a Product'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.description ?? 'No Name'),
                subtitle: Text('Code: ${item.barcode} | MRP: ${item.mrp}'),
                onTap: () {
                  Get.back();
                  _updateLayout(item);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _barcodeProcessFailed() {
    errorVibration();
    Get.defaultDialog(
      title: "Error!",
      middleText: "No Item Found. Would you like to search item?",
      textCancel: "NO",
      textConfirm: "YES",
      confirmTextColor: Colors.white,
      onCancel: () {
        clearInputs();
      },
      onConfirm: () async {
        Get.back(); // close dialog
        showSearchDialog();
      },
    );
  }

  Future<void> showSearchDialog() async {
    final result = await Get.toNamed(Routes.SEARCH);
    if (result != null && result is InventoryDataData) {
      _updateLayout(result);
    }
  }

  void _updateLayout(InventoryDataData item) async {
    currentItem = item;
    itemCode.value = item.barcode!;
    stockQty.value = item.startQty.toString();

    // Fetch the scan item to get scanQty and adjQty
    currentScanItem =
        await repository.getSingleScanItem(item.sBarcode!, item.mrp.toString());

    if (currentScanItem != null) {
      scanQty.value = currentScanItem!.scanQty.toString();
      adjustedQty.value = currentScanItem!.adjQty.toString();
    } else {
      scanQty.value = item.scanQty.toString();
      adjustedQty.value = "0.0";
    }

    barcodeController.text = item.barcode!;
    adjustQtyController.clear();
    adjustQtyFocusNode.requestFocus();
  }

  void processForSaveItem() async {
    final adjStr = adjustQtyController.text.trim();

    if (currentItem == null) {
      errorVibration();
      Get.snackbar("Error", "No Item is selected. Please select an Item first.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (adjStr.isEmpty) {
      errorVibration();
      Get.snackbar("Empty Quantity!", "Adjust Quantity is empty.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    double adjQtyVal;
    try {
      adjQtyVal = double.parse(adjStr);
      if (adjQtyVal == 0) {
        errorVibration();
        Get.snackbar("Invalid Quantity!", "Zero Quantity is not allowed.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
    } catch (e) {
      errorVibration();
      Get.snackbar("Invalid Quantity!", "Please enter a valid number.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    double newScanQty = currentScanItem != null
        ? double.tryParse(currentScanItem!.scanQty ?? '0') ?? 0.0
        : currentItem!.scanQty?.toDouble() ?? 0.0;
    double itemAdjQty = currentScanItem != null
        ? double.tryParse(currentScanItem!.adjQty ?? '0') ?? 0.0
        : 0.0;

    newScanQty = newScanQty + adjQtyVal;

    if (newScanQty < 0 || newScanQty == 0) {
      errorVibration();
      Get.snackbar("Adjust Quantity!", "Adjust quantity is not valid.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    itemAdjQty = itemAdjQty + adjQtyVal;

    if (itemAdjQty > -1000 && itemAdjQty <= 1000) {
      _saveItem(newScanQty, itemAdjQty);
    } else {
      Get.defaultDialog(
        title: "Confirmation",
        middleText: "$adjStr totalQty is confusing. Are you sure to save?",
        textCancel: "NO",
        textConfirm: "YES",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          _saveItem(newScanQty, itemAdjQty);
        },
      );
    }
  }

  void _saveItem(double newScanQty, double newAdjQty) async {
    if (currentItem == null) return;

    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final ScanItemsCompanion scanItem = ScanItemsCompanion.insert(
      itemCode: drift.Value(currentItem!.barcode),
      barcode: drift.Value(currentItem!.barcode),
      userBarcode: drift.Value(currentItem!.userBarcode),
      sBarcode: drift.Value(currentItem!.sBarcode),
      itemDescription: drift.Value(currentItem!.description),
      scanQty: drift.Value(newScanQty.toString()),
      adjQty: drift.Value(newAdjQty.toString()),
      userId: drift.Value(storage.user),
      deviceId: drift.Value(storage.deviceId),
      zoneName: drift.Value(storage.zoneName),
      scQty: drift.Value(scanQty.value),
      srQty: drift.Value(currentItem!.startQty?.toString()),
      enQty: const drift.Value("0"),
      createDate: drift.Value(dateStr),
      systemQty: drift.Value(currentItem!.startQty?.toString()),
      sQty: drift.Value(currentItem!.scanQty?.toString()),
      outletCode: drift.Value(storage.outletCode),
      salePrice: drift.Value(currentItem!.mrp?.toString()),
      cpu: drift.Value(currentItem!.cpu?.toString()),
      sessionId: drift.Value(currentItem!.sessionId),
    );

    bool isSaved = false;

    // Check if the scan item exists, if so update it, else insert it
    if (currentScanItem != null) {
      final updatedItem = currentScanItem!.copyWith(
        scanQty: drift.Value(newScanQty.toString()),
        adjQty: drift.Value(newAdjQty.toString()),
      );
      isSaved = await repository.updateScanItem(updatedItem);
    } else {
      // Doesn't exist in ScanItems yet, insert it.
      int id = await repository.addScanItem(scanItem);
      isSaved = id > 0;
    }

    if (isSaved) {
      Get.snackbar("Success", "Data saved!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      clearInputs();
    } else {
      Get.snackbar("Failed", "Data save Failed!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      clearInputs();
    }
  }
}
