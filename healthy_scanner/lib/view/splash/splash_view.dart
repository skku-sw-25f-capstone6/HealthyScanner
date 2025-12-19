import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.mainRed,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 331,
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
