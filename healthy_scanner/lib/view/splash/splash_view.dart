import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';

class SplashView extends StatefulWidget {
  final Duration duration;
  final Widget next; // 2초 후 이동할 화면

  const SplashView({
    super.key,
    required this.next,
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
    _timer = Timer(widget.duration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.next,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        ),
      );
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
                top: 309,
                left: 0,
                right: 0,
                child: Center(
                    child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 162,
                  height: 66,
                ))),
          ],
        ),
      ),
    );
  }
}
