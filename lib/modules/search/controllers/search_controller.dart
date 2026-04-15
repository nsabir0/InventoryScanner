import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/local/db.dart';

class InventorySearchController extends GetxController {
  final InventoryRepository repository;
  final searchController = TextEditingController();
  var searchResults = <InventoryDataData>[].obs;
  var isLoading = false.obs;

  InventorySearchController(this.repository);

  void search(String query) async {
    if (query.length < 3) {
      searchResults.clear();
      return;
    }
    isLoading.value = true;
    try {
      final results = await repository.searchInventory(query);
      searchResults.assignAll(results);
    } finally {
      isLoading.value = false;
    }
  }
}
