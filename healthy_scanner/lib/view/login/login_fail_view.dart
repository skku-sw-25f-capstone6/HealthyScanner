import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/bottom_button.dart';

class LoginFailView extends StatelessWidget {
  const LoginFailView({
    super.key,
    this.onRetry,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
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
                '로그인에 실패했어요',
                textAlign: TextAlign.center,
                style: context.title2Medium.copyWith(
                  color: AppColors.staticBlack,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '다시 시도해 주세요',
                textAlign: TextAlign.center,
                style: context.caption2Regular.copyWith(
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
          text: '다시 로그인하기',
          onPressed: () {
            // TODO: 다시 로그인하기 액션
          },
        ),
      ),
    );
  }
}
