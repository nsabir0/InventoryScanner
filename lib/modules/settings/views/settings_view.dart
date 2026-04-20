import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48.h,
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Server Configuration',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: controller.hostController,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                labelText: 'Host/IP Address',
                labelStyle: TextStyle(fontSize: 12.sp),
                prefixIcon: Icon(Icons.dns, size: 18.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
            ),
            SizedBox(height: 12.h),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedZoneName.value,
                  isDense: true,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Zone Name',
                    labelStyle: TextStyle(fontSize: 12.sp),
                    prefixIcon: Icon(Icons.location_on, size: 18.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  ),
                  items: controller.zoneList.map((String zone) {
                    return DropdownMenuItem<String>(
                      value: zone,
                      child: Text(zone, style: TextStyle(fontSize: 14.sp)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectedZoneName.value = newValue;
                    }
                  },
                )),
            SizedBox(height: 12.h),
            TextField(
              controller: controller.outletCodeController,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                labelText: 'Outlet Code',
                labelStyle: TextStyle(fontSize: 12.sp),
                prefixIcon: Icon(Icons.store, size: 18.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
            ),
            SizedBox(height: 12.h),
            Obx(() {
              final deviceController =
                  TextEditingController(text: controller.deviceId.value);
              return TextField(
                controller: deviceController,
                enabled: false,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                decoration: InputDecoration(
                  labelText: 'Device ID',
                  labelStyle: TextStyle(fontSize: 12.sp),
                  prefixIcon: Icon(Icons.devices, size: 18.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                ),
              );
            }),
            SizedBox(height: 24.h),
            Text(
              'Preferences',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Obx(() => SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Multi Scan Quantity',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  value: controller.isMultiScanQty.value,
                  onChanged: (value) {
                    controller.isMultiScanQty.value = value;
                  },
                )),
            Obx(() => SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Show Stock Quantity',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  value: controller.isStockVisible.value,
                  onChanged: (value) {
                    controller.isStockVisible.value = value;
                  },
                )),
            Obx(() => SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Show Item Code',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  value: controller.isItemCodeVisible.value,
                  onChanged: (value) {
                    controller.isItemCodeVisible.value = value;
                  },
                )),
            Obx(() => SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Scan by S-Barcode',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  value: controller.isScanBySBarcode.value,
                  onChanged: (value) {
                    controller.isScanBySBarcode.value = value;
                  },
                )),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: controller.saveSettings,
              icon: Icon(Icons.save, size: 18.w),
              label: Text(
                'Save Settings',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
