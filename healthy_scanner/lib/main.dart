import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'controller/navigation_controller.dart';
import 'controller/scan_controller.dart';
import 'controller/auth_controller.dart';
import 'controller/home_controller.dart';
import 'data/api_service.dart';
import 'data/home_api.dart';
import 'core/app_secure_storage.dart';
import 'core/api_client.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppRoutes.validateRoutes();
  await migrateAndCleanupSecureStorage();
  await GetStorage.init();

  ApiClient.setupInterceptors();

  Get.put(NavigationController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(ScanController(), permanent: true);
  Get.put(
    ApiService(baseUrl: ApiClient.baseUrl),
    permanent: true,
  );
  Get.put(HomeController(HomeApi(baseUrl: 'https://healthy-scanner.com')));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HealthyScanner',
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      navigatorObservers: [
        GetObserver(
          (routing) {
            if (routing?.current != null) {
              final nav = Get.find<NavigationController>();
              nav.onPageChanged(routing!.current);

              if (routing.isBack == true && routing.current == AppRoutes.home) {
                if (Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().fetchHome();
                }
              }
            }
          },
        ),
      ],
    );
  }
}
