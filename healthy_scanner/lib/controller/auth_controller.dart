import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
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

  final jwt = RxnString();
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
    jwt.value = await storage.read(key: "jwt");
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

    if (jwt.value != null && jwt.value!.isNotEmpty) {
      debugPrint("🔐 Saved JWT found → Auto login");
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
    required String jwt,
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
    required int refreshExpiresIn,
  }) async {
    debugPrint(
        "🎫 JWT prefix: ${jwt.substring(0, jwt.length > 20 ? 20 : jwt.length)}");
    debugPrint("🎫 JWT hasDot: ${jwt.contains('.')}");

    this.jwt.value = jwt;

    this.accessToken.value = accessToken;
    this.refreshToken.value = refreshToken;
    this.tokenType.value = tokenType;
    this.expiresIn.value = expiresIn;
    this.refreshExpiresIn.value = refreshExpiresIn;

    await storage.write(key: "jwt", value: jwt);

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
    await storage.delete(key: "kakao_access_token");
    await storage.delete(key: "kakao_refresh_token");
    await storage.delete(key: "kakao_token_type");
    await storage.delete(key: "kakao_expires_in");
    await storage.delete(key: "kakao_refresh_expires_in");

    jwt.value = null;
    accessToken.value = null;
    refreshToken.value = null;
    tokenType.value = null;
    expiresIn.value = null;
    refreshExpiresIn.value = null;

    debugPrint("👋 Logout success");

    nav.goToLogin();
  }

  Future<void> _callLogoutApi() async {
    try {
      final res = await ApiClient.dio.post("/auth/logout");
      debugPrint("🚪 Logout API ok: ${res.statusCode}");
    } on DioException catch (e) {
      debugPrint(
          "⚠️ Logout API failed but continue: ${e.response?.statusCode} ${e.message}");
    } catch (e) {
      debugPrint("⚠️ Logout API unknown error: $e");
    }
  }

  // ----------------------------------------------------------
  // 🧪 디버깅용 코드: 로그아웃 후 old JWT가 서버에서 차단됐는지 확인
  // ----------------------------------------------------------
  Future<void> debugVerifyOldJwtRejected(String oldJwt) async {
    try {
      final res = await ApiClient.dio.get(
        "/v1/myPage/summary",
        options: Options(
          headers: {"Authorization": "Bearer $oldJwt"},
        ),
      );

      debugPrint(
        "⚠️ [DEBUG] Old JWT still works! "
        "status=${res.statusCode}, body=${res.data}",
      );
    } on DioException catch (e) {
      debugPrint(
        "✅ [DEBUG] Old JWT rejected as expected: "
        "status=${e.response?.statusCode}, body=${e.response?.data}",
      );
    }
  }
}
