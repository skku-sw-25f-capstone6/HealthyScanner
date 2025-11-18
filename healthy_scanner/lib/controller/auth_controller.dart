import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';

class AuthController extends GetxController {
  /// 플랫폼별 FastAPI 로컬 개발용 URL
  static String get backendLoginUrl {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8000/auth/kakao/login";
    }

    if (Platform.isIOS) {
      return "http://127.0.0.1:8000/auth/kakao/login";
    }

    return "http://127.0.0.1:8000/auth/kakao/login";
  }

  final nav = Get.find<NavigationController>();

  /// ----------------------------------------------------------
  /// 1) 서버 로그인 URL을 바로 WebView로 오픈
  /// ----------------------------------------------------------
  Future<void> startKakaoLogin() async {
    // 서버는 JSON이 아니라 즉시 카카오 login 페이지로 Redirect하므로
    // 그대로 WebView에서 URL을 열면 된다.
    nav.goToKakaoWebView(backendLoginUrl);
  }

  /// ----------------------------------------------------------
  /// 2) WebView에서 JWT를 수신한 뒤 호출됨
  /// ----------------------------------------------------------
  Future<void> onLoginCompleted(String jwt, String userId) async {
    print("🎉 JWT 수신 완료: $jwt");
    print("👤 USER ID: $userId");

    // TODO: SecureStorage에 JWT 저장
    // await storage.write(key: "jwt", value: jwt);

    nav.goToHome();
  }
}
