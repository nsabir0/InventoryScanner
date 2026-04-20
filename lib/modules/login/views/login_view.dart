import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8E24AA),
              Color(0xFFD81B60),
              Color(0xFF6A1B9A),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0.w),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Offline Mode Toggle
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: controller.toggleMode,
                              child: Obx(
                                () => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12.w,
                                      height: 12.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: controller.isOnline.value
                                            ? Colors.greenAccent
                                            : Colors.grey[400],
                                        boxShadow: [
                                          if (controller.isOnline.value)
                                            BoxShadow(
                                              color: Colors.greenAccent
                                                  .withAlpha(100),
                                              blurRadius: 8.r,
                                              spreadRadius: 2.r,
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      controller.isOnline.value
                                          ? "Online Mode"
                                          : "Offline Mode",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Spacer(flex: 1),

                          // Main Content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "INVENTORY SCANNER",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2.w,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 4.h),
                                      blurRadius: 10.r,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 60.h),

                              // Username Field
                              Obx(
                                () => _buildTextField(
                                  controller: controller.userController,
                                  focusNode: controller.userFocusNode,
                                  hintText: "Username",
                                  icon: Icons.person_outline,
                                  readOnly: controller.isLoading.value,
                                  onSubmitted: (_) =>
                                      controller.handleUserSubmitted(),
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // Password Field
                              Obx(
                                () => _buildTextField(
                                  controller: controller.passwordController,
                                  focusNode: controller.passwordFocusNode,
                                  hintText: "Password",
                                  icon: Icons.lock_outline,
                                  obscureText: controller.obscurePassword.value,
                                  readOnly: controller.isLoading.value ||
                                      controller.isUserEmpty.value,
                                  suffixWidget: IconButton(
                                    icon: Icon(
                                      controller.obscurePassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white70,
                                      size: 20.w,
                                    ),
                                    onPressed: () =>
                                        controller.obscurePassword.value =
                                            !controller.obscurePassword.value,
                                  ),
                                  onSubmitted: (_) => controller.login(),
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // Login Button
                              Obx(
                                () => ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () => controller.login(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF1976D2), // Blue
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16.h),
                                    elevation: 8.r,
                                    shadowColor: Colors.black38,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          height: 24.w,
                                          width: 24.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.w,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "LOGIN",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2.w,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),

                          Spacer(flex: 2),

                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "v1.0.0",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Get.toNamed(Routes.SETTINGS),
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.orange,
                                  size: 32.w,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixWidget,
    Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        readOnly: readOnly,
        onSubmitted: onSubmitted,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
          prefixIcon: Icon(icon, color: Colors.white70, size: 20.w),
          suffixIcon: suffixWidget,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }
}
