import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../../data/local/db.dart';

class InventorySearchView extends GetView<InventorySearchController> {
  const InventorySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Search Item',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    const nativeBlue = Color(0xFF1976D2);
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: controller.search,
        decoration: InputDecoration(
          hintText: "Search by Name or Barcode...",
          prefixIcon: const Icon(Icons.search, color: nativeBlue),
          suffixIcon: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.searchText.value.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: controller.clearSearch,
                  ),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(nativeBlue),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFFFFFFF)),
                  onPressed: () =>
                      controller.search(controller.searchController.text),
                ),
              ],
            ),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text("No items found",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.searchResults.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = controller.searchResults[index];
            return _buildSearchItem(item);
          },
        );
      }),
    );
  }

  Widget _buildSearchItem(InventoryDataData item) {
    const nativeBlue = Color(0xFF1976D2);

    return InkWell(
      onTap: () => controller.selectItem(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Name
            Text(
              item.description ?? "N/A",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),

            // Barcode and MRP Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Barcode: ${item.barcode}",
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[700])),
                    if (item.userBarcode != null &&
                        item.userBarcode!.isNotEmpty)
                      Text("UserBarcode: ${item.userBarcode}",
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700])),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "MRP: ${item.mrp}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: nativeBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
