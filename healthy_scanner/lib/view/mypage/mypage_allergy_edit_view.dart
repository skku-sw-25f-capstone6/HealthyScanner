import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/mypage_controller.dart';
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
  late final NavigationController nav;
  late final MyPageController myPageController;
  late Set<String> selectedAllergies;

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

  @override
  void initState() {
    super.initState();
    nav = Get.find<NavigationController>();
    myPageController = Get.find<MyPageController>();
    selectedAllergies = {
      ...myPageController.currentAllergiesKorean,
    };
  }

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
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: allergies.map((allergy) {
                      final bool isSelected =
                          selectedAllergies.contains(allergy);

                      return TagChipToggle(
                        key: ValueKey('$allergy-$isSelected'),
                        label: allergy,
                        initialSelected: isSelected,
                        onChanged: (v) {
                          setState(() {
                            if (allergy == '없어요' && v) {
                              selectedAllergies = {'없어요'};
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
                          });
                        },
                      );
                    }).toList(),
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
                    child: Obx(() {
                      final isSaving =
                          myPageController.isUpdatingAllergies.value;
                      return BottomButton(
                        text: isSaving ? '저장 중...' : '저장하기',
                        isEnabled: !isSaving,
                        onPressed: () async {
                          final selection =
                              selectedAllergies.toList(growable: false);
                          final success = await myPageController
                              .updateAllergies(selection);
                          if (!context.mounted) return;
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('저장에 실패했어요. 다시 시도해 주세요.'),
                              ),
                            );
                            return;
                          }
                          nav.goBack();
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            // 🔹 좌상단 고정 뒤로가기 버튼
            Positioned(
              top: 20,
              left: 16,
              child: GestureDetector(
                onTap: nav.goBack,
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
