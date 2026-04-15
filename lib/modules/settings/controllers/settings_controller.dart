import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService storage = Get.find<StorageService>();

  final hostController = TextEditingController();
  final deviceIdController = TextEditingController();
  final zoneNameController = TextEditingController();
  final outletCodeController = TextEditingController();

  var isMultiScanQty = true.obs;
  var isStockVisible = true.obs;
  var isItemCodeVisible = false.obs;
  var isScanBySBarcode = true.obs;

  @override
  void onInit() {
    super.onInit();
    hostController.text =
        storage.baseUrl.replaceAll("http://", "").replaceAll("/api/", "");
    deviceIdController.text = storage.deviceId;
    zoneNameController.text = storage.zoneName;
    outletCodeController.text = storage.outletCode;

    // In a real app, these would also be in storage. For brevity, I'll just use the controllers.
  }

  void saveSettings() {
    storage.saveConfig(
      hostController.text.trim(),
      deviceIdController.text.trim(),
      zoneNameController.text.trim(),
      outletCodeController.text.trim(),
    );
    Get.back();
    Get.snackbar("Success", "Settings saved successfully");
  }
}
