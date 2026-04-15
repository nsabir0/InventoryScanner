import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/values/strings.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String get baseUrl {
    String host = _prefs.getString(AppStrings.baseUrl) ?? "";
    if (host.isEmpty) return "";
    if (!host.startsWith("http")) host = "http://$host";
    if (!host.endsWith("/")) host = "$host/";
    return "${host}api/";
  }

  set baseUrl(String value) => _prefs.setString(AppStrings.baseUrl, value);

  String get deviceId => _prefs.getString(AppStrings.deviceId) ?? "";
  set deviceId(String value) => _prefs.setString(AppStrings.deviceId, value);

  String get zoneName => _prefs.getString(AppStrings.zoneName) ?? "";
  set zoneName(String value) => _prefs.setString(AppStrings.zoneName, value);

  String get outletCode => _prefs.getString(AppStrings.outletCode) ?? "";
  set outletCode(String value) =>
      _prefs.setString(AppStrings.outletCode, value);

  String get user => _prefs.getString(AppStrings.user) ?? "";
  set user(String value) => _prefs.setString(AppStrings.user, value);

  List<String> get sessionIds =>
      _prefs.getStringList(AppStrings.sessionIds) ?? [];
  set sessionIds(List<String> value) =>
      _prefs.setStringList(AppStrings.sessionIds, value);

  bool get isOnlineMode => _prefs.getBool(AppStrings.workingMode) ?? true;
  set isOnlineMode(bool value) => _prefs.setBool(AppStrings.workingMode, value);

  String get offlineUserName =>
      _prefs.getString(AppStrings.offlineUserName) ?? "";
  set offlineUserName(String value) =>
      _prefs.setString(AppStrings.offlineUserName, value);

  String get offlinePassword =>
      _prefs.getString(AppStrings.offlinePassword) ?? "";
  set offlinePassword(String value) =>
      _prefs.setString(AppStrings.offlinePassword, value);

  void saveConfig(
      String host, String deviceId, String zoneName, String outletCode) {
    baseUrl = host;
    this.deviceId = deviceId;
    this.zoneName = zoneName;
    this.outletCode = outletCode;
  }

  void saveOfflineUserInfo(String username, String password) {
    _prefs.setString(AppStrings.offlineUserName, username);
    _prefs.setString(AppStrings.offlinePassword, password);
  }
}
