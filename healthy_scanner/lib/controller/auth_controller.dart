import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  static String backendLoginURL =
      "https://healthy-scanner.com/auth/kakao/login";
  final nav = Get.find<NavigationController>();
  final storage = const FlutterSecureStorage();

  final kakaoAccessToken = RxnString();
  final kakaoRefreshToken = RxnString();
  final kakaoTokenType = RxnString();
  final kakaoExpiresIn = RxnInt();
  final kakaoRefreshExpiresIn = RxnInt();

  @override
  void onInit() {
    super.onInit();
    _loadStoredTokens();
  }

  Future<void> _loadStoredTokens() async {
    kakaoAccessToken.value = await storage.read(key: "kakao_access_token");
    kakaoRefreshToken.value = await storage.read(key: "kakao_refresh_token");
    kakaoTokenType.value = await storage.read(key: "kakao_token_type");

    final expiresInStr = await storage.read(key: "kakao_expires_in");
    final refreshExpiresInStr =
        await storage.read(key: "kakao_refresh_expires_in");

    if (expiresInStr != null) {
      kakaoExpiresIn.value = int.tryParse(expiresInStr);
    }
    if (refreshExpiresInStr != null) {
      kakaoRefreshExpiresIn.value = int.tryParse(refreshExpiresInStr);
    }

    if (kakaoAccessToken.value != null) {
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

    kakaoAccessToken.value = accessToken;
    kakaoRefreshToken.value = refreshToken;
    kakaoTokenType.value = tokenType;
    kakaoExpiresIn.value = expiresIn;
    kakaoRefreshExpiresIn.value = refreshExpiresIn;

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
    await storage.deleteAll();

    kakaoAccessToken.value = null;
    kakaoRefreshToken.value = null;
    kakaoTokenType.value = null;
    kakaoExpiresIn.value = null;
    kakaoRefreshExpiresIn.value = null;

    nav.goToLogin();
  }
}
