import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/routes/app_routes.dart';
import 'package:healthy_scanner/theme/app_colors.dart';

class SplashView extends StatefulWidget {
  /// 스플래시 유지 시간
  final Duration duration;

  /// 다음으로 이동할 화면 (없으면 기본 라우트로 이동)
  final Widget? next;

  const SplashView({
    super.key,
    this.next, // ✅ required 제거
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // duration 후 다음 화면으로 이동
    _timer = Timer(widget.duration, () {
      if (!mounted) return;

      if (widget.next != null) {
        // ✅ next가 있으면 지정된 화면으로 이동
        Get.offAll(() => widget.next!);
      } else {
        // ✅ next가 없으면 기본적으로 로그인 메인으로 이동
        Get.offAllNamed(AppRoutes.loginMain);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.mainRed,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 329,
              left: 0,
              right: 0,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 124,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
