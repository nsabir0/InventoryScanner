part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const SCAN = _Paths.SCAN;
  static const SESSION = _Paths.SESSION;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const SCAN = '/scan';
  static const SESSION = '/session';
  static const SETTINGS = '/settings';
}
