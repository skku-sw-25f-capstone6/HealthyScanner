import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../component/bottom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class OnboardingCompleteView extends GetView<NavigationController> {
  const OnboardingCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.staticWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 인디케이터 (마지막 단계)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isActive = index == 3;
                      return Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color:
                              isActive ? AppColors.mainRed : AppColors.softGray,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 60),

                  // 🔹 텍스트 영역
                  Text(
                    '반가워요!',
                    style: AppTextStyles.title2Bold.copyWith(
                      color: AppColors.staticBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 🔹 하트 이미지 (GIF or PNG)
                  Center(
                    child: Image.network(
                      'https://i.imgur.com/1ZVmm46.gif', // ❤️ 하트 애니메이션
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🔹 서브 텍스트
                  Text(
                    '찍먹과 함께\n즐겁고 건강한 식사하세요!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.brownGray,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  // 🔹 시작 버튼
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: BottomButton(
                      text: '시작하기',
                      onPressed: controller.finishOnboarding,
                    ),
                  ),
                ],
              ),
            ),

            // 🔙 뒤로가기 버튼 (위치 고정)
            Positioned(
              top: 20,
              left: 16,
              child: GestureDetector(
                onTap: controller.goBack,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.cloudGray,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}