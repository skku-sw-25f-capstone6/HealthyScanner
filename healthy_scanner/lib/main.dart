import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'controller/navigation_controller.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // ⭐ 중요: SDK 초기화 전 반드시 필요

  // ⭐ 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'aa03c53edb5ea7f0032d5b7319adeaa0',
  );


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
