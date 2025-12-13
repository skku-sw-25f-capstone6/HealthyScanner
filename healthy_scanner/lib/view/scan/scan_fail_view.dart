import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/bottom_button.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/data/scan_fail_payload.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';

class ScanFailView extends StatelessWidget {
  const ScanFailView({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();
    final auth = Get.find<AuthController>();

    final payload = ScanFailPayload.fromArgs(
      Get.arguments as Map<String, dynamic>?,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const Image(
                image: AssetImage('assets/icons/ic_fail.png'),
                width: 128,
                height: 128,
              ),
              const SizedBox(height: 17),
              Text(
                payload.title,
                textAlign: TextAlign.center,
                style: context.body2Bold.copyWith(
                  color: AppColors.staticBlack,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                payload.message,
                textAlign: TextAlign.center,
                style: context.caption1Medium.copyWith(
                  color: AppColors.staticBlack,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: BottomButton(
          text: payload.forceLogout ? '다시 로그인하기' : '다시 시도하기',
          onPressed: () async {
            if (payload.forceLogout) {
              await Get.find<AuthController>().logout();
              return;
            }

            if (payload.suggestIngredientMode) {
              nav.replaceToScanReady(initialMode: ScanMode.ingredient);
              return;
            }

            nav.replaceToScanReady();
          },
        ),
      ),
    );
  }
}
