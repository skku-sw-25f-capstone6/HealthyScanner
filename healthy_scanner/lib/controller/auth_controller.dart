import 'dart:convert';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  /// ------------------------------------------------------------
  /// 1️⃣ 카카오 로그인 진행
  /// ------------------------------------------------------------
  Future<void> loginWithKakao() async {
    try {
      isLoading.value = true;

      OAuthToken token;

      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final kakaoAccessToken = token.accessToken;

      // 카카오 access_token → 서버 로그인 요청
      await _requestLoginToServer(
        provider: "kakao",
        kakaoAccessToken: kakaoAccessToken,
      );

    } catch (e) {
      print("❌ 카카오 로그인 실패: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// ------------------------------------------------------------
  /// 2️⃣ 서버에 로그인 요청 (provider = kakao)
  /// ------------------------------------------------------------
  Future<void> _requestLoginToServer({
    required String provider,
    required String kakaoAccessToken,
  }) async {
    final url = Uri.parse("https://api.foodscanner.com/v1/auth/login/$provider");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "access_token": kakaoAccessToken,
      }),
    );

    print("📥 서버 응답 코드: ${response.statusCode}");
    print("📥 서버 응답 body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("로그인 실패: ${response.body}");
    }

    final data = jsonDecode(response.body);

    // ✔ access_token, refresh_token, expires_in 은 다음 단계에서 저장 처리
    print("🟢 서버 access_token: ${data["access_token"]}");
    print("🟢 서버 refresh_token: ${data["refresh_token"]}");
  }
}

