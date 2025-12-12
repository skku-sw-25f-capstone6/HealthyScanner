import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/bottom_button.dart';
import '../../controller/navigation_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class OnboardingDietView extends StatefulWidget {
  const OnboardingDietView({super.key});

  @override
  State<OnboardingDietView> createState() => _OnboardingDietViewState();
}

class _OnboardingDietViewState extends State<OnboardingDietView> {
  String selectedDiet = '일반식'; // ✅ 기본 선택값

  final List<String> dietOptions = [
    '일반식',
    '생선 채식',
    '유제품 허용 채식',
    '달걀 허용 채식',
    '채식',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 인디케이터 (16x16, 간격 14)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isActive = index == 0;
                  return Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.mainRed : AppColors.softGray,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),

              // 🔹 인디케이터 아래 여백 40
              const SizedBox(height: 40),

              // 🔹 첫 번째 질문 텍스트
              Text(
                '첫 번째 질문',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.stoneGray,
                ),
              ),

              // 🔹 첫 번째 질문 아래 여백 35
              const SizedBox(height: 35),

              // 🔹 질문 내용
              Text(
                '식습관 유형에 대해\n알려주세요.',
                style: AppTextStyles.title2Medium.copyWith(
                  color: AppColors.staticBlack,
                ),
                textAlign: TextAlign.center,
              ),

              // 🔹 질문 내용 아래 여백 65
              const SizedBox(height: 65),

              // 🔹 드롭다운 (폭 260)
              SizedBox(
                width: 260,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.softGray),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedDiet,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.charcoleGray,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    dropdownColor: AppColors.staticWhite,
                    style: AppTextStyles.footnote1Medium.copyWith(
                      color: AppColors.stoneGray,
                    ),
                    items: dietOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: AppTextStyles.footnote1Medium.copyWith(
                            color: AppColors.charcoleGray,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDiet = value!;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              // 🔹 다음 버튼
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: BottomButton(
                  text: '다음',
                  isEnabled: true,
                  onPressed: controller.goToOnboardingDisease,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
