import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ApiClient extends GetxService {
  final StorageService storage = Get.find<StorageService>();
  late ApiService apiService;

  Future<ApiClient> init() async {
    apiService = ApiService();
    return this;
  }
}
