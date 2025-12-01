import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/bottom_button.dart';
import '../../component/tag_chip_toggle.dart';
import '../../controller/navigation_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class OnboardingDiseaseView extends StatefulWidget {
  const OnboardingDiseaseView({super.key});

  @override
  State<OnboardingDiseaseView> createState() => _OnboardingDiseaseViewState();
}

class _OnboardingDiseaseViewState extends State<OnboardingDiseaseView> {
  final RxSet<String> selectedDiseases = <String>{}.obs;

  // ✅ 질병 목록 (순서 및 누락 보완)
  final List<String> diseaseOptions = [
    '건강 질환이 없어요',
    '고혈압',
    '간질환',
    '통풍',
    '당뇨병',
    '고지혈증',
    '신장질환',
    '갑상선질환',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // ✅ 배경색 적용
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ 메인 콘텐츠
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 인디케이터 (2번째 단계)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isActive = index == 1;
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

                  // 🔹 인디케이터 아래 여백 40
                  const SizedBox(height: 40),

                  // 🔹 질문 순서 텍스트
                  Text(
                    '두 번째 질문',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.stoneGray,
                    ),
                  ),

                  // 🔹 질문 순서 아래 여백 35
                  const SizedBox(height: 35),

                  // 🔹 질문 내용
                  Text(
                    '주의해야 하는\n건강 질환이 있나요?',
                    style: AppTextStyles.title2Medium.copyWith(
                      color: AppColors.staticBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // 🔹 질문 내용 아래 여백 65
                  const SizedBox(height: 65),

                  // 🔹 질환 선택 칩 (TagChipToggle)
                  Obx(() {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: diseaseOptions.map((disease) {
                        final isSelected = selectedDiseases.contains(disease);
                        return TagChipToggle(
                          label: disease,
                          initialSelected: isSelected,
                          onChanged: (selected) {
                            if (selected) {
                              // ✅ ‘건강 질환이 없어요’ 선택 시 나머지 전부 해제 후 단독 선택
                              if (disease == '건강 질환이 없어요') {
                                selectedDiseases
                                  ..clear()
                                  ..add('건강 질환이 없어요');
                              }
                              // ✅ 다른 질환 선택 시 ‘건강 질환이 없어요’ 해제
                              else {
                                selectedDiseases.remove('건강 질환이 없어요');
                                selectedDiseases.add(disease);
                              }
                            } else {
                              // ✅ 다시 클릭 시 해당 질환만 해제
                              selectedDiseases.remove(disease);
                            }
                          },
                        );
                      }).toList(),
                    );
                  }),

                  const Spacer(),

                  // 🔹 안내 문구 (버튼 기준 위 15)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      '해당하는 항목이 없다면 직접 입력해 주세요.',
                      style: AppTextStyles.caption2Regular.copyWith(
                        color: AppColors.stoneGray,
                      ),
                    ),
                  ),

                  // 🔹 다음 버튼
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Obx(
                      () => BottomButton(
                        text: '다음',
                        isEnabled: selectedDiseases.isNotEmpty,
                        onPressed: controller.goToOnboardingAllergy,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ 뒤로가기 버튼 (절대 위치, 상단 고정)
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