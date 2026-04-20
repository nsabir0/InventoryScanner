import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../controllers/view_scans_controller.dart';

class UpdateScanItemView extends GetView<ViewScansController> {
  final dynamic item;
  final TextEditingController _qtyController = TextEditingController();

  UpdateScanItemView({super.key, required this.item}) {
    _qtyController.text = item.scanQty?.toString() ?? '0';
  }

  void _errorVibration() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 600);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Scan Item'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Barcode:', item.barcode ?? 'N/A'),
              const SizedBox(height: 16),
              _buildInfoRow('User Barcode:', item.userBarcode ?? 'N/A'),
              const SizedBox(height: 16),
              _buildInfoRow('Description:', item.itemDescription ?? 'N/A'),
              const SizedBox(height: 24),
              const Text(
                'Scan Quantity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _qtyController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _processUpdate(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE37F54),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('SAVE'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _errorVibration();
                        _showDeleteConfirmation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('DELETE'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _processUpdate() {
    final newQtyStr = _qtyController.text.trim();
    if (newQtyStr.isEmpty) {
      Get.dialog(
        AlertDialog(
          title: const Text('Empty Quantity!'),
          content: const Text('Scan Quantity is empty. Please enter quantity'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      _errorVibration();
      return;
    }

    final newQty = double.tryParse(newQtyStr);
    if (newQty == null || newQty <= 0) {
      Get.dialog(
        AlertDialog(
          title: const Text('Zero Quantity!'),
          content: const Text(
              'Zero Quantity is not allowed. Please enter positive quantity'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      _errorVibration();
      return;
    }

    if (newQtyStr == item.scanQty?.toString()) {
      Get.back();
    } else {
      controller.updateItemQty(item, newQty).then((_) {
        Get.back();
      });
    }
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Do you want to delete item'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // close dialog
              controller.deleteItem(item).then((_) {
                Get.back(); // close update screen
              });
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
