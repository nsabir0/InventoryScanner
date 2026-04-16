import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/inventory_repository.dart';

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
    loadScanItems();
  }

  /// Load all scan items based on mode (regular or temp)
  Future<void> loadScanItems() async {
    isLoading.value = true;
    try {
      if (isTempMode.value) {
        final items = await repository.getAllTempScanItems();
        scanItemsList.value = items;
        filteredItemsList.value = items;
      } else {
        final items = await repository.getAllScanItems();
        scanItemsList.value = items;
        filteredItemsList.value = items;
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
      filteredItemsList.value = scanItemsList;
      return;
    }

    final upperQuery = query.toUpperCase().trim();

    filteredItemsList.value = scanItemsList.where((item) {
      final barcode = (item.barcode ?? '').toString().toUpperCase();
      final userBarcode = (item.userBarcode ?? '').toString().toUpperCase();
      final sBarcode = (item.sBarcode ?? '').toString().toUpperCase();
      final description = (item.itemDescription ?? '').toString().toUpperCase();

      return barcode.contains(upperQuery) ||
          userBarcode.contains(upperQuery) ||
          sBarcode.contains(upperQuery) ||
          description.contains(upperQuery);
    }).toList();
  }

  /// Delete item from list
  Future<void> deleteItem(dynamic item) async {
    try {
      final success = await repository.deleteScanItem(item.id);
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
    // TODO: Navigate to UpdateScanItem screen when implemented
    Get.snackbar(
      "Info",
      "Update feature coming soon",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
