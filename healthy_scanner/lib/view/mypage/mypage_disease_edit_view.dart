import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../component/tag_chip_toggle.dart';
import '../../component/bottom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class MyPageDiseaseEditView extends StatefulWidget {
  const MyPageDiseaseEditView({super.key});

  @override
  State<MyPageDiseaseEditView> createState() => _MyPageDiseaseEditViewState();
}

class _MyPageDiseaseEditViewState extends State<MyPageDiseaseEditView> {
  final NavigationController controller = Get.find<NavigationController>();

  final List<String> diseases = [
    '고혈압',
    '당뇨병',
    '고지혈증',
    '비만',
    '심혈관질환',
    '신장질환',
    '간질환',
    '위염/소화질환',
    '없어요',
  ];

  final RxList<String> selectedDiseases = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // ✅ 배경색 통일
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ 메인 콘텐츠
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 타이틀
                  Text(
                    '\n\n건강 질환 정보를\n수정할 수 있어요.',
                    style: AppTextStyles.title2Medium.copyWith(
                      color: AppColors.staticBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // 🔹 부제 설명
                  Text(
                    '선택하신 질환은 식품 분석 시 주의 성분으로 표시됩니다.',
                    style: AppTextStyles.footnote1Regular.copyWith(
                      color: AppColors.brownGray,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  // 🔹 질환 선택 칩
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: diseases.map((disease) {
                        final bool isSelected =
                            selectedDiseases.contains(disease);

                        return TagChipToggle(
                          label: disease,
                          initialSelected: isSelected,
                          onChanged: (v) {
                            // ✅ ‘없어요’ 선택 시 나머지 해제
                            if (disease == '없어요' && v) {
                              selectedDiseases.clear();
                              selectedDiseases.add(disease);
                            } else {
                              if (selectedDiseases.contains('없어요')) {
                                selectedDiseases.remove('없어요');
                              }
                              if (v) {
                                selectedDiseases.add(disease);
                              } else {
                                selectedDiseases.remove(disease);
                              }
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const Spacer(),

                  // 🔹 안내 문구 (버튼 위 15)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      '해당하는 항목이 없다면 직접 입력해 주세요.',
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: AppColors.brownGray,
                      ),
                    ),
                  ),

                  // 🔹 저장 버튼
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: BottomButton(
                      text: '저장하기',
                      isEnabled: true,
                      onPressed: controller.goBack,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 좌상단 고정 뒤로가기 버튼
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