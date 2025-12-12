import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:healthy_scanner/app_secure_storage.dart';

class AuthController extends GetxController {
  static String backendLoginURL =
      "https://healthy-scanner.com/auth/kakao/login";
  final nav = Get.find<NavigationController>();
  final FlutterSecureStorage storage = appSecureStorage;

  final accessToken = RxnString();
  final refreshToken = RxnString();
  final tokenType = RxnString();
  final expiresIn = RxnInt();
  final refreshExpiresIn = RxnInt();

  @override
  void onInit() {
    super.onInit();
    _loadStoredTokens();
  }

  Future<void> _loadStoredTokens() async {
    accessToken.value = await storage.read(key: "kakao_access_token");
    refreshToken.value = await storage.read(key: "kakao_refresh_token");
    tokenType.value = await storage.read(key: "kakao_token_type");

    final expiresInStr = await storage.read(key: "kakao_expires_in");
    final refreshExpiresInStr =
        await storage.read(key: "kakao_refresh_expires_in");

    if (expiresInStr != null) {
      expiresIn.value = int.tryParse(expiresInStr);
    }
    if (refreshExpiresInStr != null) {
      refreshExpiresIn.value = int.tryParse(refreshExpiresInStr);
    }

    if (accessToken.value != null) {
      debugPrint("🔐 Saved Kakao access token found → Auto login");
      nav.goToHome();
    }
  }

  /// ----------------------------------------------------------
  /// 1) 서버 로그인 URL을 바로 WebView로 오픈
  /// ----------------------------------------------------------
  Future<void> startKakaoLogin() async {
    nav.goToKakaoWebView(backendLoginURL);
  }

  /// ----------------------------------------------------------
  /// 2) WebView에서 카카오 토큰 JSON을 수신한 뒤 호출됨
  /// ----------------------------------------------------------
  Future<void> onKakaoLoginCompleted({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
    required int refreshExpiresIn,
  }) async {
    debugPrint("🎉 Kakao access_token: $accessToken");
    debugPrint("🔁 Kakao refresh_token: $refreshToken");
    debugPrint("🔤 token_type: $tokenType");
    debugPrint("⏱ expires_in: $expiresIn");
    debugPrint("⏱ refresh_expires_in: $refreshExpiresIn");

    this.accessToken.value = accessToken;
    this.refreshToken.value = refreshToken;
    this.tokenType.value = tokenType;
    this.expiresIn.value = expiresIn;
    this.refreshExpiresIn.value = refreshExpiresIn;

    await storage.write(key: "kakao_access_token", value: accessToken);
    await storage.write(key: "kakao_refresh_token", value: refreshToken);
    await storage.write(key: "kakao_token_type", value: tokenType);
    await storage.write(key: "kakao_expires_in", value: expiresIn.toString());
    await storage.write(
        key: "kakao_refresh_expires_in", value: refreshExpiresIn.toString());

    nav.goToHome();
  }

  /// ----------------------------------------------------------
  /// 3) 로그인 실패 처리
  /// ----------------------------------------------------------
  void onLoginFailed() {
    debugPrint("❌ 카카오 로그인 실패");
    // nav.goToLoginFail();
  }

  /// ----------------------------------------------------------
  /// 4) 로그아웃
  /// ----------------------------------------------------------
  Future<void> logout() async {
    await storage.delete(key: "kakao_access_token");
    await storage.delete(key: "kakao_refresh_token");
    await storage.delete(key: "kakao_token_type");
    await storage.delete(key: "kakao_expires_in");
    await storage.delete(key: "kakao_refresh_expires_in");

    accessToken.value = null;
    refreshToken.value = null;
    tokenType.value = null;
    expiresIn.value = null;
    refreshExpiresIn.value = null;

    debugPrint("👋 로그아웃 완료");

    nav.goToLogin();
  }
}
