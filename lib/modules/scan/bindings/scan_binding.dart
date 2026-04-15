import 'package:get/get.dart';
import '../controllers/scan_controller.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/local/db.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryRepository>(() => InventoryRepository(Get.find<AppDatabase>()));
    Get.lazyPut<ScanController>(() => ScanController(Get.find<InventoryRepository>()));
  }
}
