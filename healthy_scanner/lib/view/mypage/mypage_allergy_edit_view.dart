import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../component/tag_chip_toggle.dart';
import '../../component/bottom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class MyPageAllergyEditView extends StatefulWidget {
  const MyPageAllergyEditView({super.key});

  @override
  State<MyPageAllergyEditView> createState() => _MyPageAllergyEditViewState();
}

class _MyPageAllergyEditViewState extends State<MyPageAllergyEditView> {
  final NavigationController controller = Get.find<NavigationController>();

  final List<String> allergies = [
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

  final RxList<String> selectedAllergies = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // ✅ 배경색 변경
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 메인 콘텐츠
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 페이지 제목
                  Text(
                    '\n\n알레르기 정보를\n수정할 수 있어요.',
                    style: AppTextStyles.title2Medium.copyWith(
                      color: AppColors.staticBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // 🔹 부제 설명
                  Text(
                    '선택하신 알레르기 성분은 스캔 시 자동으로\n위험 식품을 표시해드릴게요.',
                    style: AppTextStyles.footnote1Regular.copyWith(
                      color: AppColors.brownGray,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  // 🔹 알레르기 선택 영역
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: allergies.map((allergy) {
                        final bool isSelected =
                            selectedAllergies.contains(allergy);

                        return TagChipToggle(
                          label: allergy,
                          initialSelected: isSelected,
                          onChanged: (v) {
                            // ‘없어요’ 선택 시 나머지 해제
                            if (allergy == '없어요' && v) {
                              selectedAllergies.clear();
                              selectedAllergies.add(allergy);
                            } else {
                              if (selectedAllergies.contains('없어요')) {
                                selectedAllergies.remove('없어요');
                              }
                              if (v) {
                                selectedAllergies.add(allergy);
                              } else {
                                selectedAllergies.remove(allergy);
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
                      ' ',
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
