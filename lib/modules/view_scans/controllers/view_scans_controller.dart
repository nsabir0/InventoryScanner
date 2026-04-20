import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../views/update_scan_item_view.dart';

class ViewScansController extends GetxController {
  final InventoryRepository repository;

  var scanItemsList = <dynamic>[].obs;
  var filteredItemsList = <dynamic>[].obs;
  var isLoading = false.obs;
  var searchText = ''.obs;
  var isTempMode = false.obs;

  ViewScansController(this.repository);

  @override
  void onInit() {
    super.onInit();
    // Listen for mode changes and reload
    ever(isTempMode, (_) => loadScanItems());
  }

  /// Called by the View to initialize the mode and trigger loading
  void initMode(bool mode) {
    if (isTempMode.value != mode) {
      // This will trigger 'ever' which calls loadScanItems()
      isTempMode.value = mode;
    } else if (scanItemsList.isEmpty) {
      // Force load if empty even if mode didn't change
      loadScanItems();
    }
  }

  /// Load all scan items based on mode (regular or temp)
  Future<void> loadScanItems() async {
    isLoading.value = true;
    try {
      if (isTempMode.value) {
        final items = await repository.getAllTempScanItems();
        scanItemsList.assignAll(items);
        filteredItemsList.assignAll(items);
      } else {
        final items = await repository.getAllScanItems();
        scanItemsList.assignAll(items);
        filteredItemsList.assignAll(items);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load scan items: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Search items by barcode
  void searchItems(String query) {
    searchText.value = query;

    if (query.isEmpty) {
      filteredItemsList.assignAll(scanItemsList);
      return;
    }

    final upperQuery = query.toUpperCase().trim();

    final results = scanItemsList.where((item) {
      final barcode = (item.barcode ?? '').toString().toUpperCase();
      final userBarcode = (item.userBarcode ?? '').toString().toUpperCase();
      final sBarcode = (item.sBarcode ?? '').toString().toUpperCase();
      final description = (item.itemDescription ?? '').toString().toUpperCase();

      return barcode.contains(upperQuery) ||
          userBarcode.contains(upperQuery) ||
          sBarcode.contains(upperQuery) ||
          description.contains(upperQuery);
    }).toList();
    
    filteredItemsList.assignAll(results);
  }

  /// Delete item from list
  Future<void> deleteItem(dynamic item) async {
    try {
      bool success = false;
      if (isTempMode.value) {
        success = await repository.deleteTempScanItem(item.id);
      } else {
        success = await repository.deleteScanItem(item.id);
      }
      
      if (success) {
        await loadScanItems();
        Get.snackbar(
          "Success",
          "Item deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete item: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  /// Update an item's quantity
  Future<void> updateItemQty(dynamic item, double newQty) async {
    try {
      bool success = false;
      if (isTempMode.value) {
        final updatedItem = item.copyWith(scanQty: newQty.toString());
        success = await repository.updateTempScanItem(updatedItem);
      } else {
        final updatedItem = item.copyWith(scanQty: newQty.toString());
        success = await repository.updateScanItem(updatedItem);
      }

      if (success) {
        await loadScanItems();
        Get.snackbar(
          "Success",
          "Item Updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update item: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  /// Delete all temp scan items
  Future<void> deleteAllTempItems() async {
    try {
      await repository.deleteAllTempScanItems();
      await loadScanItems();
      Get.snackbar(
        "Success",
        "All temp items deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete temp items: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Navigate to update item screen
  void navigateToUpdateItem(dynamic item) {
    Get.to(() => UpdateScanItemView(item: item));
  }
}
