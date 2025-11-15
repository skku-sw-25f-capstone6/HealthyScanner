import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  static const String kakaoRestApiKey = "f06abe24b27ed244d8da3ec0cfb34b2e";  // REST API 키
  static const String redirectUri = "https://healthy-scanner.com/auth/kakao/callback";
  static const String serverLoginUrl = "https://api.foodscanner.com/v1/auth/login/kakao";

  final storage = const FlutterSecureStorage();
  StreamSubscription? _linkSub;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    //웹에서 열 때 예외처리
    if (!GetPlatform.isWeb) {
    _listenDeepLinks();
    }

  }

  @override
  void onClose() {
    _linkSub?.cancel();
    super.onClose();
  }

  /// 1) 카카오 로그인 URL 생성
  String _buildKakaoLoginUrl() {
    return "https://kauth.kakao.com/oauth/authorize"
        "?client_id=$kakaoRestApiKey"
        "&redirect_uri=$redirectUri"
        "&response_type=code";
  }

  /// 2) 카카오 로그인 창 열기
  Future<void> loginWithKakao() async {
    try {
      isLoading.value = true;

      final url = _buildKakaoLoginUrl();
      print("🔗 카카오 로그인 URL: $url");

      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

    } catch (e) {
      print("❌ 카카오 로그인 열기 실패: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 3) deep link 수신
  void _listenDeepLinks() {
    _linkSub = linkStream.listen((String? link) async {
      if (link == null) return;

      print("🔄 DeepLink 감지: $link");

      final uri = Uri.parse(link);

      if (uri.scheme == "healthyScanner" && uri.host == "kakao-login") {
        final code = uri.queryParameters["code"];
        if (code != null) {
          await _handleAuthCode(code);
        }
      }
    });
  }

  /// 4) Authorization Code → AccessToken 교환
  Future<void> _handleAuthCode(String code) async {
    try {
      print("🔐 Auth Code 수신: $code");

      final url = Uri.parse("https://kauth.kakao.com/oauth/token");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "grant_type": "authorization_code",
          "client_id": kakaoRestApiKey,
          "redirect_uri": redirectUri,
          "code": code,
        },
      );

      final json = jsonDecode(response.body);
      final kakaoAccessToken = json["access_token"];

      print("🟢 카카오 access_token: $kakaoAccessToken");

      await _loginToServer(kakaoAccessToken);

    } catch (e) {
      print("❌ 토큰 교환 실패: $e");
    }
  }

  /// 5) 서버 로그인 요청
  Future<void> _loginToServer(String token) async {
    try {
      final url = Uri.parse(serverLoginUrl);

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"access_token": token}),
      );

      print("📥 서버 응답 코드: ${response.statusCode}");
      print("📥 서버 응답 body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("서버 로그인 실패: ${response.body}");
      }

      final data = jsonDecode(response.body);

      await storage.write(key: "access_token", value: data["access_token"]);
      await storage.write(key: "refresh_token", value: data["refresh_token"]);

      print("🟢 로그인 성공: 토큰 저장 완료");

    } catch (e) {
      print("❌ 서버 로그인 실패: $e");
    }
  }
}
