import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../component/bottom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class MyPageDietEditView extends StatefulWidget {
  const MyPageDietEditView({super.key});

  @override
  State<MyPageDietEditView> createState() => _MyPageDietEditViewState();
}

class _MyPageDietEditViewState extends State<MyPageDietEditView> {
  String selectedDiet = '일반식';

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
      backgroundColor: const Color(0xFFFAFAFA), // ✅ 변경된 배경색
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 메인 타이틀
                  Text(
                    '\n\n식습관 유형을\n수정할 수 있어요.',
                    style: AppTextStyles.title2Medium.copyWith(
                      color: AppColors.staticBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // 🔹 부제 설명
                  Text(
                    '선택하신 식습관은 향후 맞춤 식품 추천에 반영됩니다.',
                    style: AppTextStyles.footnote1Regular.copyWith(
                      color: AppColors.brownGray,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 65),

                  // 🔹 드롭다운
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
                          color: AppColors.staticBlack,
                        ),
                        items: dietOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(
                              option,
                              style: AppTextStyles.footnote1Medium.copyWith(
                                color: AppColors.stoneGray,
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

            // 🔹 뒤로가기 버튼 (좌상단 고정)
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
