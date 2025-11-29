import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/navigation_controller.dart';
import '../../component/bottom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class OnboardingAgreeView extends GetView<NavigationController> {
  const OnboardingAgreeView({super.key});

  final String policyUrl =
      'https://useful-maxilla-d92.notion.site/2a590ccf2e8180278f0bf9ce95ea8140?source=copy_link';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _customCheckbox({
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: value ? AppColors.mainRed : Colors.transparent,
          border: Border.all(
            color: value ? AppColors.mainRed : AppColors.softGray,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: value
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 100, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 제목
              Text(
                '찍먹에 오신 것을\n환영합니다!',
                style: AppTextStyles.title2Medium.copyWith(
                  color: AppColors.staticBlack,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '서비스 이용을 위해 아래 약관에 동의해 주세요',
                style: AppTextStyles.caption1Medium.copyWith(
                  color: AppColors.brownGray,
                ),
              ),

              const Spacer(),

              // ✅ 체크 항목
              Obx(() {
                bool allChecked = controller.agreedPolicy.value &&
                    controller.agreedService.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 전체 동의
                    Row(
                      children: [
                        _customCheckbox(
                          value: allChecked,
                          onChanged: (v) {
                            controller.agreedPolicy.value = v;
                            controller.agreedService.value = v;
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '전체 동의',
                          style: AppTextStyles.caption1Medium.copyWith(
                            color: AppColors.stoneGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // 개인정보 처리방침 동의
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _customCheckbox(
                          value: controller.agreedPolicy.value,
                          onChanged: (v) =>
                              controller.agreedPolicy.value = v,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.caption1Medium.copyWith(
                                color: AppColors.stoneGray,
                              ),
                              children: [
                                const TextSpan(text: '개인정보 처리방침 동의 ( '),
                                TextSpan(
                                  text: '개인정보처리방침',
                                  style: AppTextStyles.caption1Medium.copyWith(
                                    color: AppColors.mainRed,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _openUrl(policyUrl),
                                ),
                                const TextSpan(text: ' )'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // 서비스 이용 약관 동의
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _customCheckbox(
                          value: controller.agreedService.value,
                          onChanged: (v) =>
                              controller.agreedService.value = v,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.caption1Medium.copyWith(
                                color: AppColors.stoneGray,
                              ),
                              children: [
                                const TextSpan(text: '서비스 이용 약관 동의 ( '),
                                TextSpan(
                                  text: '서비스이용약관',
                                  style: AppTextStyles.caption1Medium.copyWith(
                                    color: AppColors.mainRed,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _openUrl(policyUrl),
                                ),
                                const TextSpan(text: ' )'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              const SizedBox(height: 32),

              // ✅ 하단 버튼
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: BottomButton(
                    text: '시작하기',
                    isEnabled: controller.isAgreeValid,
                    onPressed: controller.goToOnboardingDiet,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}