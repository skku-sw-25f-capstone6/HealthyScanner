import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/food_card.dart';
import 'package:healthy_scanner/component/traffic_light.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    // ✅ 임시 스캔 리스트 (API 연동 전까지 더미 데이터)
    final items = List<_FoodItem>.generate(
      3,
      (i) => _FoodItem(
        title: '칸쵸',
        category: '과자 / 초콜릿가공품',
        message: '포화지방과 당류가 다소 높고,\n땅콩이 포함되어 있어요.',
        imageAsset: 'assets/images/cancho.png',
        warningAsset: 'assets/icons/ic_warning.png',
        lightState: TrafficLightState.red,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 상단 점수 및 날짜
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: AppColors.mainRed,
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    const Text(
                      '87',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '오늘의 찍먹 점수',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateTime.now().month}월 ${DateTime.now().day}일',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // 섹션 제목
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    Text(
                      '최근 스캔 내역',
                      style: context.bodyMedium.copyWith(
                        color: AppColors.staticBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ 카드 리스트
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final it = items[index];
                  return FoodCard(
                    title: it.title,
                    category: it.category,
                    message: it.message,
                    imageAsset: it.imageAsset,
                    warningAsset: it.warningAsset,
                    lightState: it.lightState,
                    onTap: () {
                      nav.goToAnalysisResult(); // ✅ 분석 결과 페이지로 이동
                    },
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      // 하단 네비게이션 바
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 홈
              IconButton(
                icon: const Icon(Icons.home_outlined),
                color: AppColors.mainRed,
                onPressed: () {},
              ),

              // 카메라 (중앙)
              FloatingActionButton(
                backgroundColor: AppColors.mainRed,
                elevation: 4,
                onPressed: () {
                  nav.goToScanReady();
                },
                child: const Icon(Icons.camera_alt_rounded),
              ),

              // 마이페이지
              IconButton(
                icon: const Icon(Icons.person_outline),
                color: AppColors.charcoleGray,
                onPressed: () {
                  nav.goToMyPage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔸 임시 스캔 아이템 모델
class _FoodItem {
  final String title;
  final String category;
  final String message;
  final String imageAsset;
  final String? warningAsset;
  final TrafficLightState lightState;

  _FoodItem({
    required this.title,
    required this.category,
    required this.message,
    required this.imageAsset,
    this.warningAsset,
    this.lightState = TrafficLightState.green,
  });
}
