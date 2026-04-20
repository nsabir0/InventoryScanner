import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../../data/repositories/inventory_repository.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventorySearchController>(
      () => InventorySearchController(Get.find<InventoryRepository>()),
    );
  }
}
