import 'package:get/get.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final InventoryRepository repository;
  final StorageService storage = Get.find<StorageService>();

  var totalInventoryItems = 0.obs;
  var sessionText = "No session selected".obs;

  HomeController(this.repository);

  @override
  void onInit() {
    super.onInit();
    updateSessionInfo();
    refreshInventoryCount();
  }

  void updateSessionInfo() {
    if (storage.sessionIds.isEmpty) {
      sessionText.value = "No session selected";
    } else {
      sessionText.value = "Running Sessions: ${storage.sessionIds.join(', ')}";
    }
  }

  Future<void> refreshInventoryCount() async {
    totalInventoryItems.value = await repository.countInventoryItems();
  }

  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> deleteSessions(String password) async {
    if (password == storage.offlinePassword) {
      await repository.deleteAllScanItems();
      await repository.clearInventoryData();
      await repository.addUsedSessions(storage.sessionIds);
      storage.sessionIds = [];
      updateSessionInfo();
      refreshInventoryCount();
      Get.snackbar("Success", "Sessions deleted successfully.");
      logout();
    } else {
      Get.snackbar("Error", "Incorrect Password");
    }
  }
}
