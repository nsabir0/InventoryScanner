import 'package:get/get.dart';
import '../controllers/adjust_controller.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/local/db.dart';

class AdjustBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdjustController>(
      () => AdjustController(
        InventoryRepository(Get.find<AppDatabase>()),
        Get.find<StorageService>(),
      ),
    );
  }
}
