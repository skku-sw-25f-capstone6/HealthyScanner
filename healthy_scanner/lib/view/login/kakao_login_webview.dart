import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';

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
          // ✔ URL 로딩 전에 가로채기
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            print("🌐 Navigation request: $url");

            // healthy://callback?jwt=...&userId=...
            if (url.startsWith("healthy://callback")) {
              final uri = Uri.parse(url);

              final jwt = uri.queryParameters["jwt"];
              final userId = uri.queryParameters["userId"]; // ⬅ 수정됨!

              print("🎉 Custom callback URL detected!");
              print("JWT: $jwt");
              print("USER ID: $userId");

              if (jwt != null && userId != null) {
                auth.onLoginCompleted(jwt, userId);
              }

              Get.back(); // WebView 닫기
              return NavigationDecision.prevent; // WebView에서 URL을 열지 않게 막기
            }

            return NavigationDecision.navigate;
          },

          onPageFinished: (url) {
            print("🔎 WebView loaded: $url");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loginUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("카카오 로그인")),
      body: WebViewWidget(controller: controller),
    );
  }
}
