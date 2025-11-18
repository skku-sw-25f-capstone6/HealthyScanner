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

            if (url.startsWith("healthy://callback")) {
              final uri = Uri.parse(url);

              final jwt = uri.queryParameters["jwt"];
              final userId = uri.queryParameters["userId"];

              debugPrint("🎉 Custom callback URL detected!");
              debugPrint("JWT: $jwt");
              debugPrint("USER ID: $userId");

              if (jwt != null && userId != null) {
                auth.onLoginCompleted(jwt, userId);
              }

              Get.back();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
            debugPrint("🔎 WebView loaded: $url");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loginUrl));
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
      body: WebViewWidget(controller: controller),
    );
  }
}
