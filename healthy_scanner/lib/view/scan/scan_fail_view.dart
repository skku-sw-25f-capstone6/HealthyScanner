import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/bottom_button.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';

class ScanFailView extends StatelessWidget {
  const ScanFailView({
    super.key,
    this.onRetry,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

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
              // TODO: 발생한 에러에 따라 분기 처리
              Text(
                '오류가 발생했어요',
                textAlign: TextAlign.center,
                style: context.body2Bold.copyWith(
                  color: AppColors.staticBlack,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '사진을 다시 촬영해 주세요',
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

      // 하단 버튼
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: BottomButton(
          text: '다시 시도하기',
          onPressed: () {
            nav.replaceToScanReady();
          },
        ),
      ),
    );
  }
}
