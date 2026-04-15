import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final StorageService storage = Get.find<StorageService>();
  final ApiClient apiClient = Get.find<ApiClient>();

  final userController = TextEditingController();
  final passwordController = TextEditingController();

  var isOnline = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isOnline.value = storage.isOnlineMode;
  }

  void toggleMode() {
    isOnline.value = !isOnline.value;
    storage.isOnlineMode = isOnline.value;
  }

  Future<void> login() async {
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
        Get.offAllNamed(Routes.HOME);
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
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar("Error", "Invalid username or password.");
    }
  }
}
