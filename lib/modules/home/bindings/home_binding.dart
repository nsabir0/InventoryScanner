import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/local/db.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryRepository>(() => InventoryRepository(Get.find<AppDatabase>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<InventoryRepository>()));
  }
}
