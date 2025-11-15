import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'controller/navigation_controller.dart';

void main() {
  Get.put(NavigationController());
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
