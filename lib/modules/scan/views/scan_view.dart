import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.toNamed('/view-temp'), // Placeholder for View Temp
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Temp Total Scan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Obx(() => Text(controller.tempTotalScanQty.value, 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue))),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Total Scan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Obx(() => Text(controller.totalScanQty.value, 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green))),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            TextField(
              controller: controller.barcodeController,
              decoration: InputDecoration(
                labelText: "Barcode",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    // Trigger camera scanner
                  },
                ),
              ),
              onSubmitted: controller.onBarcodeSubmitted,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.itemCodeController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Item Code"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller.stockQtyController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Stock Qty"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
              controller.description.value.isEmpty ? "No description available" : controller.description.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
            Obx(() => Text("MRP: ${controller.mrp.value}", style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: controller.scanQtyController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: "Scan Qty"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Multi Qty", style: TextStyle(fontSize: 10)),
                      Obx(() => Checkbox(
                        value: controller.isMultiQty.value,
                        onChanged: (val) => controller.isMultiQty.value = val ?? true,
                      )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () => controller.clearInputs(),
                    child: const Text("CLEAR"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.saveItem(),
                    child: const Text("ENTER/SAVE"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => controller.saveToLocal(),
              child: const Text("SAVE TO LOCAL"),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Get.toNamed('/search'), // Placeholder for Search
              icon: const Icon(Icons.search),
              label: const Text("ITEM SEARCH"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          onPressed: () {
            // Server upload logic
          },
          child: const Text("SAVE TO SERVER"),
        ),
      ),
    );
  }
}
