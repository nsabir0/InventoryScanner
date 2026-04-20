import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'data/services/storage_service.dart';
import 'data/providers/api_client.dart';
import 'data/local/db.dart';
import 'data/repositories/inventory_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global dependencies before running the app
  await Get.putAsync(() => StorageService().init(), permanent: true);
  Get.put(AppDatabase(), permanent: true);
  Get.put(InventoryRepository(Get.find<AppDatabase>()), permanent: true);
  await Get.putAsync(() => ApiClient().init(), permanent: true);

  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: "Inventory Scanner",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
        );
      },
    ),
  );
}
