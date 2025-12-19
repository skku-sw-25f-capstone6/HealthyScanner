import 'package:get/get.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';

class SplashController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _nav = Get.find<NavigationController>();

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(seconds: 1));

    final ok = await _auth.bootstrapAutoLogin();
    if (ok) {
      // TODO: 최초가입자 온보딩으로 라우팅
      // _nav.routeAfterLogin();
      _nav.goToOnboardingAgree();
    } else {
      _nav.goToLogin();
    }
  }
}
