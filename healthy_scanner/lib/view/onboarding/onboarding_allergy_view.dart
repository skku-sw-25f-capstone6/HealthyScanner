import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../component/tag_chip_toggle.dart';
import '../../component/bottom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class OnboardingAllergyView extends GetView<NavigationController> {
  const OnboardingAllergyView({super.key});

  @override
  Widget build(BuildContext context) {
    final allergies = [
      '조개류',
      '새우',
      '견과류',
      '계란',
      '복숭아',
      '사과',
      '밀',
      '파인애플',
      '생선',
      '대두(콩)',
      '유제품',
      '소고기',
      '없어요',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 메인 콘텐츠
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 인디케이터 (3번째 단계)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isActive = index == 2;
                      return Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.mainRed
                              : AppColors.softGray,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 40),

                  // 🔹 질문 순서
                  Text(
                    '세 번째 질문',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.stoneGray,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // 🔹 메인 질문
                  Text(
                    '주의해야 하는\n알레르기가 있나요?',
                    style: AppTextStyles.title2Medium.copyWith(
                      color: AppColors.staticBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),



                  const SizedBox(height: 50),

                  // 🔹 알레르기 선택 칩
                  Obx(() {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: allergies.map((allergy) {
                        final bool isSelected =
                            controller.selectedAllergies.contains(allergy);

                        return TagChipToggle(
                          label: allergy,
                          initialSelected: isSelected,
                          onChanged: (v) {
                            // ✅ '없어요' 선택 시 다른 알러지 해제
                            if (allergy == '없어요' && v) {
                              controller.selectedAllergies.clear();
                              controller.selectedAllergies.add('없어요');
                            } else {
                              if (controller.selectedAllergies
                                  .contains('없어요')) {
                                controller.selectedAllergies.remove('없어요');
                              }
                              if (v) {
                                controller.selectedAllergies.add(allergy);
                              } else {
                                controller.selectedAllergies.remove(allergy);
                              }
                            }
                          },
                        );
                      }).toList(),
                    );
                  }),

                  const Spacer(),



                  // 🔹 다음 버튼
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Obx(
                      () => BottomButton(
                        text: '다음',
                        isEnabled: controller.isAllergyValid,
                        onPressed: controller.goToOnboardingComplete,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 뒤로가기 버튼 (절대 고정)
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