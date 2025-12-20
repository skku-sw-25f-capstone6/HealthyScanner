import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/app_typography.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/controller/analysis_edit_controller.dart';

class AnalysisEditView extends StatelessWidget {
  AnalysisEditView({
    super.key,
    required this.scanId,
    required this.initialName,
  });

  final String scanId;
  final String initialName;

  final nav = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      AnalysisEditController(scanId: scanId, initialName: initialName),
      tag: scanId,
    );

    return Scaffold(
      backgroundColor: AppColors.staticWhite,
      body: SafeArea(
        child: Column(
          children: [
            // 상단바
            SizedBox(
              height: 52,
              child: Row(
                children: [
                  const SizedBox(width: 20),

                  // 뒤로가기
                  GestureDetector(
                    onTap: nav.goBack,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.cloudGray,
                      size: 24,
                    ),
                  ),

                  const Spacer(),

                  // 타이틀
                  Text(
                    '정보 수정',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.staticBlack,
                    ),
                  ),

                  const Spacer(),

                  // 저장
                  GestureDetector(
                    onTap: c.save,
                    child: Text(
                      '저장',
                      style: AppTextStyles.footnote1Medium.copyWith(
                        color: AppColors.staticBlack,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "상품명",
                    style: AppTextStyles.footnote2Bold
                        .copyWith(color: AppColors.staticBlack),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: c.nameTEC,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.charcoleGray),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: AppColors.charcoleGray,
                      onSubmitted: (_) => c.save(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    final err = c.error.value;
                    if (err == null) return const SizedBox.shrink();
                    return Text(
                      err,
                      style: AppTextStyles.caption1Regular
                          .copyWith(color: AppColors.mainRed),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
