import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/adjust_controller.dart';

class AdjustView extends GetView<AdjustController> {
  const AdjustView({super.key});

  @override
  Widget build(BuildContext context) {
    const nativeBlue = Color(0xFF1976D2);
    const nativeRed = Color(0xFFD32F2F);
    const nativeOrange = Color(0xFFF57C00);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        toolbarHeight: 40.h,
        title: Text(
          'Adjust Quantity',
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
            // Top Tab Buttons (Optional, native only had a single form, but we can add item search button here)
            SizedBox(
              height: 35.h,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.showSearchDialog,
                icon: Icon(Icons.search, size: 16.sp, color: Colors.black),
                label: Text("ITEM SEARCH",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp)),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r)),
                  backgroundColor: Colors.white,
                ),
              ),
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
                spacing: 4.h,
                children: [
                  // Barcode Row
                  _buildInputRow(
                    "Barcode:",
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.barcodeController,
                            focusNode: controller.barcodeFocusNode,
                            onSubmitted: controller.onBarcodeSubmitted,
                            style: TextStyle(fontSize: 13.sp),
                            decoration: _inputDecoration("Scan/Enter Barcode"),
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

                  // Item Code Row
                  _buildInputRow(
                    "Item Code:",
                    Obx(() => _buildReadOnlyField(controller.itemCode.value)),
                  ),

                  // Stock Qty Row
                  _buildInputRow(
                    "Stock Qty:",
                    Obx(() => _buildReadOnlyField(controller.stockQty.value)),
                  ),

                  // Scan Qty Row
                  _buildInputRow(
                    "Scan Qty:",
                    Obx(() => _buildReadOnlyField(controller.scanQty.value)),
                  ),

                  // Adjusted Qty Row
                  _buildInputRow(
                    "Adjusted Qty:",
                    Obx(() => _buildReadOnlyField(controller.adjustedQty.value)),
                  ),

                  // Adjust Qty Row
                  _buildInputRow(
                    "Adjust Qty:",
                    TextField(
                      controller: controller.adjustQtyController,
                      focusNode: controller.adjustQtyFocusNode,
                      style: TextStyle(fontSize: 13.sp),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      onSubmitted: (_) => controller.processForSaveItem(),
                      decoration: _inputDecoration("Enter +/- Qty"),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons Grid
            SizedBox(
              height: 30.h,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child:
                          _actionButton("Cancel", nativeOrange, () => Get.back())),
                  SizedBox(width: 7.w),
                  Expanded(
                      child: _actionButton(
                          "Save", nativeBlue, controller.processForSaveItem)),
                  SizedBox(width: 7.w),
                  Expanded(
                      child:
                          _actionButton("Clear", nativeRed, controller.clearInputs)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Text(
        value.isEmpty ? " " : value,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
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

  Widget _actionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: color,
        foregroundColor: Colors.white,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
      child: FittedBox(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
