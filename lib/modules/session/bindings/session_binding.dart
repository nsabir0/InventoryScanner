import 'package:get/get.dart';
import '../controllers/session_controller.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/local/db.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryRepository>(
        () => InventoryRepository(Get.find<AppDatabase>()));
    Get.lazyPut<SessionController>(
        () => SessionController(Get.find<InventoryRepository>()));
  }
}
