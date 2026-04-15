import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService extends GetxService {
  var isConnected = true.obs;

  Future<ConnectivityService> init() async {
    InternetConnection().onStatusChange.listen((status) {
      isConnected.value = status == InternetStatus.connected;
    });
    return this;
  }
}
