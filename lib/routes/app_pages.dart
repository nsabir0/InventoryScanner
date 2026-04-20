import 'package:get/get.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import '../modules/session/views/session_view.dart';
import '../modules/session/bindings/session_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/view_scans/views/view_scans_view.dart';
import '../modules/view_scans/bindings/view_scans_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/adjust/views/adjust_view.dart';
import '../modules/adjust/bindings/adjust_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SCAN,
      page: () => const ScanView(),
      binding: ScanBinding(),
    ),
    GetPage(
      name: _Paths.SESSION,
      page: () => const SessionView(),
      binding: SessionBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_SCANS,
      page: () => ViewScansView(isTempMode: false),
      binding: ViewScansBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_TEMP_SCANS,
      page: () => ViewScansView(isTempMode: true),
      binding: ViewScansBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const InventorySearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.ADJUST,
      page: () => const AdjustView(),
      binding: AdjustBinding(),
    ),
  ];
}
