import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';

class KakaoLoginWebView extends StatefulWidget {
  final String loginUrl;
  const KakaoLoginWebView({super.key, required this.loginUrl});

  @override
  State<KakaoLoginWebView> createState() => _KakaoLoginWebViewState();
}

class _KakaoLoginWebViewState extends State<KakaoLoginWebView> {
  late final WebViewController controller;
  final auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            debugPrint("🌐 Navigation request: $url");
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) async {
            debugPrint("🔎 WebView loaded: $url");

            final uri = Uri.tryParse(url);
            if (uri == null) return;

            final isRealCallback = uri.scheme == 'https' &&
                uri.host == 'healthy-scanner.com' &&
                uri.path == '/auth/kakao/callback';

            if (isRealCallback) {
              await _handleCallbackPage();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loginUrl));
  }

  Future<void> _handleCallbackPage() async {
    try {
      final result = await controller
          .runJavaScriptReturningResult('document.body.innerText');

      final bodyText = result is String ? result : result.toString();
      debugPrint("📄 Callback body: $bodyText");

      if (bodyText.trim().isEmpty) {
        throw const FormatException("Empty response body");
      }

      final data = jsonDecode(bodyText) as Map<String, dynamic>;

      final appAccessToken = data["app_access_token"] as String?;
      final appRefreshToken = data["app_refresh_token"] as String?;
      final userId = data["user_id"]?.toString();

      final kakaoAccessToken = data["kakao_access_token"] as String?;
      final kakaoRefreshToken = data["kakao_refresh_token"] as String?;
      final tokenType = data["token_type"] as String?;
      final expiresIn = (data["expires_in"] as num?)?.toInt();
      final refreshExpiresIn = (data["refresh_expires_in"] as num?)?.toInt();

      if (appAccessToken != null &&
          appRefreshToken != null &&
          kakaoAccessToken != null &&
          kakaoRefreshToken != null &&
          userId != null &&
          userId.isNotEmpty) {
        await auth.onKakaoLoginCompleted(
          appAccessToken: appAccessToken,
          appRefreshToken: appRefreshToken,
          kakaoAccessToken: kakaoAccessToken,
          kakaoRefreshToken: kakaoRefreshToken,
          tokenType: tokenType,
          expiresIn: expiresIn,
          refreshExpiresIn: refreshExpiresIn,
          userId: userId,
        );
      } else {
        debugPrint("⚠️ Missing required fields in login response: $data");
        auth.onLoginFailed();
      }
    } catch (e, st) {
      debugPrint("❌ Failed to parse callback JSON: $e\n$st");
      auth.onLoginFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainRed,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Image.asset(
            'assets/icons/ic_chevron_left.png',
            width: 24,
            height: 24,
            color: AppColors.staticWhite,
          ),
        ),
        title: Text(
          "카카오 로그인",
          style: context.bodyMedium.copyWith(
            color: AppColors.staticWhite,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
        ],
      ),
    );
  }
}
