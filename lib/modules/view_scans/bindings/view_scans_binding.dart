import 'package:get/get.dart';
import '../controllers/view_scans_controller.dart';
import '../../../data/repositories/inventory_repository.dart';

class ViewScansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewScansController>(
      () => ViewScansController(Get.find<InventoryRepository>()),
    );
  }
}
