import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'controller/navigation_controller.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';

void main() {
  Get.put(NavigationController());
  Get.put(AuthController());
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
              Get.find<NavigationController>().onPageChanged(routing!.current!);
            }
          },
        ),
      ],
    );
  }
}
