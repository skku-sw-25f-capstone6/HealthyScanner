import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:healthy_scanner/core/app_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:healthy_scanner/core/api_client.dart';

class AuthController extends GetxController {
  static String backendLoginURL =
      "https://healthy-scanner.com/auth/kakao/login";
  final nav = Get.find<NavigationController>();
  final FlutterSecureStorage storage = appSecureStorage;

  final appAccess = RxnString();
  final kakaoAccess = RxnString();
  final kakaoRefresh = RxnString();
  final tokenType = RxnString();
  final expiresIn = RxnInt();
  final refreshExpiresIn = RxnInt();

  @override
  void onInit() {
    super.onInit();
    _loadStoredTokens();
  }

  Future<void> _loadStoredTokens() async {
    appAccess.value = await storage.read(key: "jwt");
    kakaoAccess.value = await storage.read(key: "kakao_access_token");
    kakaoRefresh.value = await storage.read(key: "kakao_refresh_token");
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

    if (appAccess.value != null && appAccess.value!.isNotEmpty) {
      debugPrint("🔐 Saved AccessToken found → Auto login");
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
    required String appAccessToken,
    required String appRefreshToken,
    required String kakaoAccessToken,
    required String kakaoRefreshToken,
    String? tokenType,
    int? expiresIn,
    int? refreshExpiresIn,
  }) async {
    debugPrint(
        "🎫 AccessToken prefix: ${appAccessToken.substring(0, appAccessToken.length > 20 ? 20 : appAccessToken.length)}");

    appAccess.value = appAccessToken;
    await storage.write(key: "jwt", value: appAccessToken);
    await storage.write(key: "app_refresh_token", value: appRefreshToken);
    kakaoAccess.value = kakaoAccessToken;
    kakaoRefresh.value = kakaoRefreshToken;
    this.tokenType.value = tokenType;
    this.expiresIn.value = expiresIn;
    this.refreshExpiresIn.value = refreshExpiresIn;

    await storage.write(key: "kakao_access_token", value: kakaoAccessToken);
    await storage.write(key: "kakao_refresh_token", value: kakaoRefreshToken);
    if (tokenType != null) {
      await storage.write(key: "kakao_token_type", value: tokenType);
    }
    if (expiresIn != null) {
      await storage.write(key: "kakao_expires_in", value: expiresIn.toString());
    }
    if (refreshExpiresIn != null) {
      await storage.write(
          key: "kakao_refresh_expires_in", value: refreshExpiresIn.toString());
    }

    nav.goToHome();
  }

  /// ----------------------------------------------------------
  /// 3) 로그인 실패 처리
  /// ----------------------------------------------------------
  void onLoginFailed() {
    debugPrint("❌ Kakao Login Failed");
    // nav.goToLoginFail();
  }

  /// ----------------------------------------------------------
  /// 4) 로그아웃
  /// ----------------------------------------------------------
  Future<void> logout() async {
    await _callLogoutApi();

    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();

    await storage.delete(key: "jwt");
    await storage.delete(key: "app_refresh_token");
    await storage.delete(key: "kakao_access_token");
    await storage.delete(key: "kakao_refresh_token");
    await storage.delete(key: "kakao_token_type");
    await storage.delete(key: "kakao_expires_in");
    await storage.delete(key: "kakao_refresh_expires_in");

    appAccess.value = null;
    kakaoAccess.value = null;
    kakaoRefresh.value = null;
    tokenType.value = null;
    expiresIn.value = null;
    refreshExpiresIn.value = null;

    debugPrint("👋 Logout success");

    nav.goToLogin();
  }

  Future<void> _callLogoutApi() async {
    try {
      final res = await ApiClient.dioClient.post(
        "/auth/logout",
        options: dio.Options(extra: {"skipRefresh": true}),
      );

      debugPrint("🚪 Logout API ok: ${res.statusCode}");
    } catch (e) {
      debugPrint("⚠️ Logout API failed but continue: $e");
    }
  }

  /// ----------------------------------------------------------
  /// 5) 계정 탈퇴(연동 해제)
  /// ----------------------------------------------------------
  Future<void> withdrawAccount() async {
    try {
      final res = await ApiClient.dioClient.delete("/auth/unlink");
      debugPrint("🗑️ Withdraw API ok: ${res.statusCode}, body=${res.data}");
      await logout();
    } catch (e) {
      debugPrint("❌ Withdraw API failed: $e");
      Get.snackbar("계정 탈퇴 실패", "잠시 후 다시 시도해주세요.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

// ----------------------------------------------------------
// 🔁 6) 토큰 재발급
// ----------------------------------------------------------
  Future<String?> refreshAppToken() async {
    final refresh = await storage.read(key: "app_refresh_token");
    if (refresh == null || refresh.isEmpty) {
      debugPrint("❌ No app refresh token saved");
      return null;
    }

    try {
      final res = await ApiClient.dioClient.post(
        "/auth/refresh",
        data: {"app_refresh_token": refresh},
      );

      final data = (res.data as Map).cast<String, dynamic>();
      final newAccessToken = data["app_access_token"] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        debugPrint("❌ Refresh response missing app_access_token: $data");
        return null;
      }

      appAccess.value = newAccessToken;
      await storage.write(key: "jwt", value: newAccessToken);

      debugPrint("✅ Token refreshed");
      return newAccessToken;
    } catch (e) {
      debugPrint("❌ Refresh failed: $e");
      return null;
    }
  }
}
