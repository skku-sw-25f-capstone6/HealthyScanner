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
          onPageFinished: (url) async {
            print("🔎 WebView loaded: $url");

            // login-success 페이지가 아닐 때 JS 실행하면 크래시 발생
            if (!url.contains("login-success")) return;

            try {
              final jsResult = await controller
                  .runJavaScriptReturningResult("document.body.innerText");

              // JS 반환 문자열 정제
              final cleaned = jsResult.toString().replaceAll('"', '');
              final data = jsonDecode(cleaned);

              final jwt = data["jwt"];
              final userId = data["user_id"];

              print("🎉 JWT received: $jwt");

              await auth.onLoginCompleted(jwt, userId);
            } catch (e) {
              print("❌ Error parsing JWT: $e");
            }
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
