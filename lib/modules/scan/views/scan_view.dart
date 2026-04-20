import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../routes/app_pages.dart';
import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    const nativeOrange = Color(0xFFF57C00);
    const nativeBlue = Color(0xFF1976D2);
    const nativeRed = Color(0xFFD32F2F);
    const nativeGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        toolbarHeight: 40.h,
        title: Text(
          'Inventory Scanner',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(7.0.w),
        child: Column(
          spacing: 7.h,
          children: [
            // Top Tab Buttons
            Row(
              children: [
                Expanded(
                  child: _topTabButton("BARCODE", true, _startScanner),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: _topTabButton(
                      "ITEM SEARCH", false, controller.showSearchDialog),
                ),
              ],
            ),

            // Main Input Card
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 9.r,
                      offset: Offset(0, 4.h)),
                ],
              ),
              child: Column(
                spacing: 2.h,
                children: [
                  // Barcode Row
                  _buildInputRow(
                    "Barcode:",
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.barcodeController,
                            onSubmitted: controller.onBarcodeSubmitted,
                            style: TextStyle(fontSize: 13.sp),
                            decoration: _inputDecoration(""),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        SizedBox(
                          height: 38.h,
                          child: ElevatedButton(
                            onPressed: () => controller.onBarcodeSubmitted(
                                controller.barcodeController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: nativeBlue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r)),
                            ),
                            child: Text("Enter",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Style Name Row
                  _buildInputRow(
                    "Style Name:",
                    Obx(() => Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: Text(
                            controller.description.value.isEmpty
                                ? " "
                                : controller.description.value,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w500),
                          ),
                        )),
                  ),

                  // MRP Row
                  _buildInputRow(
                    "MRP:",
                    Obx(() => Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: Text(
                            controller.mrp.value.isEmpty
                                ? " "
                                : controller.mrp.value,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),

                  // Scan Qty Row
                  _buildInputRow(
                    "Scan Qty:",
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => TextField(
                              enabled: controller.isMultiQty.isTrue,
                              controller: controller.scanQtyController,
                              style: TextStyle(fontSize: 13.sp),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: _inputDecoration("00"),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Obx(
                          () => Transform.scale(
                            scale: 0.65,
                            child: Switch(
                              value: controller.isMultiQty.value,
                              onChanged: controller.toggleMultiQty,
                              activeTrackColor: Colors.pink.withAlpha(128),
                              activeColor: Colors.pink,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        Text("Multi Qty",
                            style: TextStyle(
                                fontSize: 10.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons Grid
            Column(
              spacing: 5.h,
              children: [
                // Row 1: Close, Save, Clear
                SizedBox(
                  height: 30.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: _actionButton(
                              "Close", nativeOrange, () => Get.back())),
                      SizedBox(width: 7.w),
                      Expanded(
                          child: _actionButton(
                              "Save", nativeBlue, controller.saveItemToTemp)),
                      SizedBox(width: 7.w),
                      Expanded(
                          child: _actionButton(
                              "Clear", nativeRed, controller.clearInputs)),
                    ],
                  ),
                ),

                // Row 2: Temp Scan Qty Row
                SizedBox(
                  height: 30.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text("Temp Qty:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp))),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Obx(() => Container(
                              // padding: EdgeInsets.symmetric(vertical: 4.h),
                              decoration: BoxDecoration(
                                  color: nativeOrange,
                                  borderRadius: BorderRadius.circular(4.r)),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(controller.tempTotalScanQty.value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                          child: _actionButton("View", nativeBlue,
                              () => Get.toNamed(Routes.VIEW_TEMP_SCANS))),
                    ],
                  ),
                ),

                // Row 3: Save to local (Full Width)
                SizedBox(
                  height: 30.h,
                  width: double.infinity,
                  child: _actionButton("Save to local", nativeGreen,
                      controller.saveToLocalConfirmation,
                      isFullWidth: true),
                ),

                // Row 4: Total Scan Qty Row
                SizedBox(
                  height: 30.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text("Total Qty:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp))),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Obx(() => Container(
                              // padding: EdgeInsets.symmetric(vertical: 4.h),
                              decoration: BoxDecoration(
                                  color: nativeRed,
                                  borderRadius: BorderRadius.circular(4.r)),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(controller.totalScanQty.value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                          child: _actionButton("View", nativeBlue,
                              () => Get.toNamed(Routes.VIEW_SCANS))),
                    ],
                  ),
                ),

                // Row 5: Export Excel, Save to server
                SizedBox(
                  height: 30.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: _actionButton("Export Excel", nativeBlue,
                              controller.exportToExcel)),
                      SizedBox(width: 7.w),
                      Expanded(
                          child: _actionButton("Save server", nativeGreen,
                              controller.saveToServer)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _topTabButton(String label, bool isActive, VoidCallback onPressed) {
    return SizedBox(
      height: 35.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
        ),
        child: Text(label,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp)),
      ),
    );
  }

  Widget _buildInputRow(String label, Widget input) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 80.w,
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp))),
        Expanded(child: input),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12.sp),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.r)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(4.r)),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onPressed,
      {bool isFullWidth = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: color,
        foregroundColor: Colors.white,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        // minimumSize: Size(0, 40.h),
      ),
      child: FittedBox(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isFullWidth ? 14.sp : 11.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _startScanner() {
    Get.to(() => Scaffold(
          appBar: AppBar(
            toolbarHeight: 48.h,
            title: Text("Scan Barcode", style: TextStyle(fontSize: 18.sp)),
          ),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  Get.back();
                  controller.onBarcodeSubmitted(code);
                }
              }
            },
          ),
        ));
  }
}
