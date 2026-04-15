import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Services are already initialized in main(), just create the controller
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
