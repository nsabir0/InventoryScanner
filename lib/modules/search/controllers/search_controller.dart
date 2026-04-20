import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/local/db.dart';
import '../../../data/services/storage_service.dart';

class InventorySearchController extends GetxController {
  final InventoryRepository repository;
  final StorageService storage = Get.find<StorageService>();

  final searchController = TextEditingController();
  var searchResults = <InventoryDataData>[].obs;
  var isLoading = false.obs;

  var searchText = "".obs;

  InventorySearchController(this.repository);

  void onSearchChanged(String query) {
    searchText.value = query;
    if (query.length >= 3) {
      search(query);
    } else {
      searchResults.clear();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = "";
    searchResults.clear();
  }

  Future<void> search(String query) async {
    isLoading.value = true;
    try {
      // Native logic: Try online if online mode is enabled, otherwise use local DB
      // Note: Repository already handles the abstraction of local/remote search
      final results = await repository.searchInventory(query);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar("Error", "Search failed: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void selectItem(InventoryDataData item) {
    Get.back(result: item);
  }
}
