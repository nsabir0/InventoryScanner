import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/repositories/inventory_repository.dart';

class SettingsController extends GetxController {
  final StorageService storage = Get.find<StorageService>();
  final inventoryRepo = Get.find<InventoryRepository>();

  final hostController = TextEditingController();
  final zoneNameController = TextEditingController();
  final outletCodeController = TextEditingController();

  var isMultiScanQty = true.obs;
  var isStockVisible = true.obs;
  var isItemCodeVisible = false.obs;
  var isScanBySBarcode = true.obs;

  var deviceId = ''.obs;
  var selectedZoneName = 'Other'.obs;
  var usedSessionIds = <String>[].obs;

  final List<String> zoneList = ['Front Office', 'Back Office', 'Other'];

  @override
  void onInit() {
    super.onInit();
    _getDeviceId();
    _fetchUsedSessions();
    hostController.text =
        storage.baseUrl.replaceAll("http://", "").replaceAll("/api/", "");
    zoneNameController.text = storage.zoneName;
    outletCodeController.text = storage.outletCode;

    isMultiScanQty.value = storage.isMultiScanQty;
    isStockVisible.value = storage.isStockVisible;
    isItemCodeVisible.value = storage.isItemCodeVisible;
    isScanBySBarcode.value = storage.isScanBySBarcode;

    // Set selected zone from storage
    if (storage.zoneName.isNotEmpty && zoneList.contains(storage.zoneName)) {
      selectedZoneName.value = storage.zoneName;
    }
  }

  Future<void> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId.value = androidInfo.id; // This is the ANDROID_ID
    } else if (GetPlatform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId.value = iosInfo.identifierForVendor ?? '';
    } else {
      // For other platforms, use a fallback
      deviceId.value = 'unknown';
    }
  }

  Future<void> _fetchUsedSessions() async {
    final sessions = await inventoryRepo.getUsedSessionIds();
    usedSessionIds.assignAll(sessions);
  }

  void copyDeviceIdToClipboard() {
    if (deviceId.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: deviceId.value));
      Get.snackbar("Copied!", "Device ID: ${deviceId.value}",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2));
    }
  }

  void saveSettings() {
    storage.saveConfig(
      hostController.text.trim(),
      deviceId.value,
      selectedZoneName.value,
      outletCodeController.text.trim(),
    );

    storage.isMultiScanQty = isMultiScanQty.value;
    storage.isStockVisible = isStockVisible.value;
    storage.isItemCodeVisible = isItemCodeVisible.value;
    storage.isScanBySBarcode = isScanBySBarcode.value;

    Get.back();
    Get.snackbar("Success", "Settings saved successfully");
  }
}
