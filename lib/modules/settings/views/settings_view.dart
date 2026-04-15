import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Server Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.hostController,
              decoration: const InputDecoration(
                labelText: 'Host/IP Address',
                prefixIcon: Icon(Icons.dns),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.deviceIdController,
              decoration: const InputDecoration(
                labelText: 'Device ID',
                prefixIcon: Icon(Icons.devices),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.zoneNameController,
              decoration: const InputDecoration(
                labelText: 'Zone Name',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.outletCodeController,
              decoration: const InputDecoration(
                labelText: 'Outlet Code',
                prefixIcon: Icon(Icons.store),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => SwitchListTile(
                  title: const Text('Multi Scan Quantity'),
                  value: controller.isMultiScanQty.value,
                  onChanged: (value) {
                    controller.isMultiScanQty.value = value;
                  },
                )),
            Obx(() => SwitchListTile(
                  title: const Text('Show Stock Quantity'),
                  value: controller.isStockVisible.value,
                  onChanged: (value) {
                    controller.isStockVisible.value = value;
                  },
                )),
            Obx(() => SwitchListTile(
                  title: const Text('Show Item Code'),
                  value: controller.isItemCodeVisible.value,
                  onChanged: (value) {
                    controller.isItemCodeVisible.value = value;
                  },
                )),
            Obx(() => SwitchListTile(
                  title: const Text('Scan by S-Barcode'),
                  value: controller.isScanBySBarcode.value,
                  onChanged: (value) {
                    controller.isScanBySBarcode.value = value;
                  },
                )),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: controller.saveSettings,
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
