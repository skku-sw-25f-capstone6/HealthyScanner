import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 뒤로가기 버튼
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.cloudGray, size: 22),
                    onPressed: controller.goBack,
                  ),
                ),
                const SizedBox(height: 8),

                // 🔹 프로필 카드
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.mainRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.warmGray,
                        child: Icon(Icons.person,
                            color: AppColors.staticWhite, size: 40),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '김캡스',
                            style: AppTextStyles.title2Medium.copyWith(
                              color: AppColors.staticWhite,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '총 스캔 횟수 21회',
                            style: AppTextStyles.footnote1Regular.copyWith(
                              color: AppColors.staticWhite,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 식습관 / 질환 / 알레르기 구역
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.staticWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        icon: Icons.local_florist_outlined,
                        label: '식습관',
                        onTap: controller.goToMyPageDietEdit,
                      ),
                      _buildInfoItem(
                        icon: Icons.medical_services_outlined,
                        label: '건강 질환',
                        onTap: controller.goToMyPageDiseaseEdit,
                      ),
                      _buildInfoItem(
                        icon: Icons.sentiment_neutral_outlined,
                        label: '알레르기',
                        onTap: controller.goToMyPageAllergyEdit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 설정 메뉴
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.staticWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        label: '고객센터',
                        onTap: () {
                          // TODO: 고객센터 연결
                        },
                      ),
                      _divider(),
                      _buildSettingItem(
                        label: '이용 약관',
                        onTap: () {
                          // TODO: WebView로 약관 연결
                        },
                      ),
                      _divider(),
                      _buildSettingItem(
                        label: '개인정보 처리방침',
                        onTap: () {
                          // TODO: WebView로 개인정보 연결
                        },
                      ),
                      _divider(),
                      _buildSettingItem(
                        label: '로그아웃',
                        onTap: controller.logout,
                      ),
                      _divider(),
                      _buildSettingItem(
                        label: '계정 탈퇴',
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text('계정을 정말 탈퇴하시겠어요?'),
                              content: const Text('탈퇴 후 데이터는 복구되지 않습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.logout(); // 임시로 로그아웃 처리
                                  },
                                  child: const Text('탈퇴'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 개별 메뉴 아이템
  Widget _buildSettingItem({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Text(
          label,
          style: AppTextStyles.footnote1Medium.copyWith(
            color: AppColors.staticBlack,
          ),
        ),
      ),
    );
  }

  // 🔹 구분선
  Widget _divider() => Container(
        height: 1,
        color: AppColors.softGray,
        margin: const EdgeInsets.symmetric(horizontal: 16),
      );

  // 🔹 상단 식습관/질환/알레르기 아이콘 섹션
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.brownGray, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.footnote1Medium.copyWith(
              color: AppColors.brownGray,
            ),
          ),
        ],
      ),
    );
  }
}
