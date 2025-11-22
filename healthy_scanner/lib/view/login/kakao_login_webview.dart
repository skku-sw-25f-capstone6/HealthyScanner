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

            if (url.contains('/auth/kakao/callback')) {
              await _handleCallbackPage();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loginUrl));
  }

  Future<void> _handleCallbackPage() async {
    try {
      // TODO: 서버 응답에서 refresh token, 유저 정보 등 변경 발생 시 반영 필요
      final result = await controller
          .runJavaScriptReturningResult('document.body.innerText');

      final bodyText = result is String ? result : result.toString();
      debugPrint("📄 Callback body: $bodyText");

      final data = jsonDecode(bodyText) as Map<String, dynamic>;
      final jwt = data['jwt'] as String?;
      final userId = (data['user_id'] ?? data['userId'])?.toString();

      debugPrint("🎉 Parsed JWT: $jwt");
      debugPrint("👤 Parsed USER ID: $userId");

      if (jwt != null && userId != null) {
        await auth.onLoginCompleted(jwt, userId);
      } else {
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
