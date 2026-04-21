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
        toolbarHeight: 40.h,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: TextButton.icon(
              onPressed: controller.saveSettings,
              icon: Icon(Icons.save_rounded, color: Colors.white, size: 18.w),
              label: Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp),
              ),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                backgroundColor: Colors.white.withAlpha(40),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10.0.w, 0.0, 10.0.w, 0.0),
              child: Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Server Configuration',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  _buildInputSection(),
                  Text(
                    'Preferences',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  _buildSwitchSection(),
                ],
              ),
            ),
          ),
          _buildButtonSection(),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        spacing: 5.h,
        children: [
          SizedBox(
            height: 35.h,
            child: TextField(
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
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.0),
              ),
            ),
          ),
          Obx(() => SizedBox(
                height: 35.h,
                child: DropdownButtonFormField<String>(
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
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.0),
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
                ),
              )),
          SizedBox(
            height: 35.h,
            child: TextField(
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
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.0),
              ),
            ),
          ),
          Obx(() {
            return SizedBox(
              height: 35.h,
              child: TextField(
                controller:
                    TextEditingController(text: controller.deviceId.value),
                readOnly: true,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                decoration: InputDecoration(
                  labelText: 'Device ID',
                  labelStyle: TextStyle(fontSize: 12.sp),
                  prefixIcon: Icon(Icons.devices, size: 18.w),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.copy, size: 16.w, color: Colors.blue),
                    padding: EdgeInsets.zero,
                    constraints:
                        BoxConstraints(minWidth: 32.w, minHeight: 32.w),
                    onPressed: controller.copyDeviceIdToClipboard,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.0),
                ),
              ),
            );
          }),
          Obx(
            () {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Used Session IDs',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3.h),
                    if (controller.usedSessionIds.isEmpty)
                      Text(
                        'No session used before',
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
                      )
                    else
                      Text(
                        controller.usedSessionIds.join('\n'),
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[800],
                            height: 1.5),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        spacing: 5.h,
        children: [
          Obx(() => SizedBox(
                height: 25.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Multi Scan Quantity',
                        style: TextStyle(fontSize: 14.sp)),
                    Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: controller.isMultiScanQty.value,
                        onChanged: (value) =>
                            controller.isMultiScanQty.value = value,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              )),
          Obx(
            () => SizedBox(
              height: 25.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Show Stock Quantity',
                      style: TextStyle(fontSize: 14.sp)),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: controller.isStockVisible.value,
                      onChanged: (value) =>
                          controller.isStockVisible.value = value,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => SizedBox(
              height: 25.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Show Item Code', style: TextStyle(fontSize: 14.sp)),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: controller.isItemCodeVisible.value,
                      onChanged: (value) =>
                          controller.isItemCodeVisible.value = value,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => SizedBox(
              height: 25.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Scan by S-Barcode', style: TextStyle(fontSize: 14.sp)),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: controller.isScanBySBarcode.value,
                      onChanged: (value) =>
                          controller.isScanBySBarcode.value = value,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection() {
    return Padding(
      padding: EdgeInsets.all(10.0.w),
      child: ElevatedButton.icon(
        onPressed: controller.saveSettings,
        icon: Icon(Icons.save, size: 16.w),
        label: Text(
          'Save Settings',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50.h),
          // padding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
      ),
    );
  }
}
