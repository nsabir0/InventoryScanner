import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/view_scans_controller.dart';

class ViewScansView extends GetView<ViewScansController> {
  final bool isTempMode;

  ViewScansView({super.key, this.isTempMode = false}) {
    Get.find<ViewScansController>().initMode(isTempMode);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(isTempMode ? 'View Temp Scan Items' : 'View Scan Items'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
          // Search Bar - Matches native Android design with orange background
          Container(
            color: const Color(0xFFE37F54), // Native Android orange color
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => controller.searchItems(value),
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      hintStyle: const TextStyle(fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Trigger search with current text
                    controller.searchItems(controller.searchText.value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE37F54),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredItemsList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading scan items...'),
                    ],
                  ),
                );
              }

              if (controller.filteredItemsList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.isTempMode.value
                            ? 'No temp scan items found'
                            : 'No scan items found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.filteredItemsList.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredItemsList[index];
                  return _buildScanItemCard(item);
                },
              );
            }),
          ),

          // Delete All button for temp items
          Obx(() {
            if (controller.isTempMode.value &&
                controller.scanItemsList.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteAllConfirmation(),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text(
                      'DELETE ALL TEMP ITEMS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    ),
  );
}

  /// Build individual scan item card - Matches native Android design
  Widget _buildScanItemCard(dynamic item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () => controller.navigateToUpdateItem(item),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barcode
              _buildInfoRow('Barcode:', item.barcode ?? 'N/A'),
              const SizedBox(height: 4),

              // User Barcode
              _buildInfoRow('User Barcode:', item.userBarcode ?? 'N/A'),
              const SizedBox(height: 4),

              // Item Description (Style Name)
              _buildInfoRow('Style Name:', item.itemDescription ?? 'N/A'),
              const SizedBox(height: 4),

              // Scan Quantity
              _buildInfoRow('Scan Qty:', item.scanQty ?? '0'),
            ],
          ),
        ),
      ),
    );
  }

  /// Build info row with label and value
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  /// Show confirmation dialog for deleting all temp items
  void _showDeleteAllConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Do you want to Delete All Items?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteAllTempItems();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
