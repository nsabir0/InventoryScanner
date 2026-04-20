import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final storage = Get.find<StorageService>();
  final apiClient = Get.find<ApiClient>();
  final repository = Get.find<InventoryRepository>();

  final userController = TextEditingController();
  final passwordController = TextEditingController();

  var userFocusNode = FocusNode();
  var passwordFocusNode = FocusNode();

  var isOnline = true.obs;
  var isLoading = false.obs;
  var obscurePassword = true.obs;
  var isUserEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    isOnline.value = storage.isOnlineMode;
    userController.addListener(() {
      isUserEmpty.value = userController.text.trim().isEmpty;
    });
    Timer(Duration(milliseconds: 200), () {
      userFocusNode.requestFocus();
    });
  }

  void handleUserSubmitted() {
    if (userController.text.trim().isEmpty) {
      userFocusNode.requestFocus();
    } else {
      passwordFocusNode.requestFocus();
    }
  }

  void toggleMode() {
    isOnline.value = !isOnline.value;
    storage.isOnlineMode = isOnline.value;
  }

  Future<void> login() async {
    if (isLoading.isTrue) return;

    if (storage.outletCode.isEmpty || storage.zoneName.isEmpty) {
      Get.snackbar("Error", "Configuration missing. Please check settings.");
      return;
    }

    if (isOnline.value && storage.baseUrl.isEmpty) {
      Get.snackbar("Error", "IP address not found. Please check settings.");
      return;
    }

    String userName = userController.text.trim();
    String password = passwordController.text.trim();

    if (userName.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter username and password.");
      return;
    }

    if (isOnline.value) {
      await _onlineLogin(userName, password);
    } else {
      _offlineLogin(userName, password);
    }
  }

  Future<void> _onlineLogin(String userName, String password) async {
    isLoading.value = true;
    try {
      final response = await apiClient.apiService.login(
        userName: userName,
        password: password,
      );

      if (response.status) {
        storage.saveOfflineUserInfo(userName, password);
        storage.user = userName;

        // Navigate based on mode and existing data (matches native Android logic)
        await _navigateAfterLogin();
      } else {
        Get.snackbar("Login Failed", response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      String errorMessage = e.toString();
      // Extract clean error message
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.split('Exception:').last.trim();
      }
      Get.snackbar("Connection Error", errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4));
    } finally {
      isLoading.value = false;
    }
  }

  void _offlineLogin(String userName, String password) {
    if (storage.offlineUserName.isEmpty) {
      Get.snackbar("Error", "Please login first in online mode");
    } else if (storage.offlineUserName == userName &&
        storage.offlinePassword == password) {
      // Offline mode always goes to Home (matches native Android)
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar("Error", "Invalid username or password.");
    }
  }

  /// Navigate to appropriate screen after login (matches native Android logic)
  /// Native: LoginActivity.java line 159-170
  Future<void> _navigateAfterLogin() async {
    try {
      // Check if there's existing scan data
      final totalScanQty = await repository.getTotalScanQty();
      final tempScanQty = await repository.getTempTotalScanQty();

      final bool hasScanData = (totalScanQty != null && totalScanQty > 0) ||
          (tempScanQty != null && tempScanQty > 0);

      // Native logic:
      // if (!isOnlineMode || (isOnlineMode && hasScanData)) -> MainActivity (Home)
      // else -> SessionActivity
      if (!isOnline.value || hasScanData) {
        // Offline mode OR has existing data -> Go to Home
        Get.offAllNamed(Routes.HOME);
      } else {
        // Online mode AND no data -> Go to Session screen
        Get.offAllNamed(Routes.SESSION);
      }
    } catch (e) {
      // If error checking data, default to Session for online mode
      if (isOnline.value) {
        Get.offAllNamed(Routes.SESSION);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    }
  }
}
