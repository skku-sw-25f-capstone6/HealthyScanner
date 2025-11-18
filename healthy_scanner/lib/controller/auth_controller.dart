import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  /// 플랫폼별 FastAPI 로컬 개발용 URL
  static String get BACKEND_LOGIN_URL => Platform.isAndroid
      ? "http://10.0.2.2:8000/auth/kakao/login?platform=android"
      : "http://localhost:8000/auth/kakao/login?platform=ios";

  final nav = Get.find<NavigationController>();
  final storage = const FlutterSecureStorage();

  final jwt = RxnString();
  final userId = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadStoredTokens();
  }

  Future<void> _loadStoredTokens() async {
    jwt.value = await storage.read(key: "jwt");
    userId.value = await storage.read(key: "userId");

    if (jwt.value != null) {
      debugPrint("🔐 Saved JWT found → Auto login");
      nav.goToHome();
    }
  }

  /// ----------------------------------------------------------
  /// 1) 서버 로그인 URL을 바로 WebView로 오픈
  /// ----------------------------------------------------------
  Future<void> startKakaoLogin() async {
    nav.goToKakaoWebView(BACKEND_LOGIN_URL);
  }

  /// ----------------------------------------------------------
  /// 2) WebView에서 JWT를 수신한 뒤 호출됨
  /// ----------------------------------------------------------
  Future<void> onLoginCompleted(String token, String uid) async {
    debugPrint("🎉 JWT 수신 완료: $token");
    debugPrint("👤 USER ID: $uid");

    jwt.value = token;
    userId.value = uid;

    await storage.write(key: "jwt", value: token);
    await storage.write(key: "userId", value: uid);

    nav.goToHome();
  }

  /// ----------------------------------------------------------
  /// 3) 로그인 실패 처리
  /// ----------------------------------------------------------
  void onLoginFailed() {
    debugPrint("❌ 카카오 로그인 실패");
    nav.goToLoginFail();
  }

  /// ----------------------------------------------------------
  /// 4) 로그아웃
  /// ----------------------------------------------------------
  Future<void> logout() async {
    await storage.deleteAll();
    jwt.value = null;
    userId.value = null;

    nav.goToLogin();
  }
}
