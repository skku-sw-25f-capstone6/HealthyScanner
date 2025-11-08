import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/food_card.dart';
import 'package:healthy_scanner/component/traffic_light.dart';
import 'package:healthy_scanner/component/shutter_button.dart';
import 'package:healthy_scanner/view/home/home_progress_bar.dart';
import 'package:healthy_scanner/view/home/home_curved_clipper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  final score = 87; // TODO: 실제 점수로 바인딩

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    // 상단바 색상 커스텀
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.mainRed,
        statusBarIconBrightness: Brightness.dark, // Android용
        statusBarBrightness: Brightness.light, // iOS용
      ),
    );

    // 임시 스캔 리스트 (API 연동 전까지 더미 데이터)
    final items = List<_FoodItem>.generate(
      2,
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
      backgroundColor: AppColors.staticWhite,
      extendBody: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: BottomArcClipper(
              arcHeight: 25,
            ),
            child: Container(
              color: AppColors.mainRed,
              child: Column(
                children: [
                  // 상태바
                  Container(
                    height: MediaQuery.of(context).padding.top,
                    color: AppColors.mainRed,
                  ),

                  // 점수·게이지 영역
                  Padding(
                    padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Spacer(),
                            Image(
                              image: AssetImage('assets/icons/ic_mypage.png'),
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 점수 시각화 반원
                              SemiCircularProgress(
                                value: score / 100.0,
                                size: 224,
                                thickness: 14,
                                offsetY: 50,
                                bgColor: const Color(0x33FFFFFF),
                                fgColor: AppColors.staticWhite,
                              ),

                              // 중앙 텍스트 (점수 + 라벨)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$score',
                                    style: context.largeTitle
                                        .copyWith(color: AppColors.staticWhite),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '오늘의 찍먹 점수',
                                    style: context.footnote2Medium
                                        .copyWith(color: AppColors.staticWhite),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    '${DateTime.now().month}월 ${DateTime.now().day}일',
                                    style: context.bodyMedium
                                        .copyWith(color: AppColors.staticWhite),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Container(
              color: AppColors.backgroundGray,
              child:
                  // 성분 카드 (최대 2개, 스크롤 없음)
                  Padding(
                padding: const EdgeInsets.fromLTRB(12, 27, 12, 0),
                child: Column(
                  children: [
                    FoodCard(
                      title: items[0].title,
                      category: items[0].category,
                      message: items[0].message,
                      imageAsset: items[0].imageAsset,
                      warningAsset: items[0].warningAsset,
                      lightState: items[0].lightState,
                      onTap: () {},
                    ),
                    const SizedBox(height: 15),
                    if (items.length > 1)
                      FoodCard(
                        title: items[1].title,
                        category: items[1].category,
                        message: items[1].message,
                        imageAsset: items[1].imageAsset,
                        warningAsset: items[1].warningAsset,
                        lightState: items[1].lightState,
                        onTap: () {},
                      ),
                  ],
                ),
              ),
            ),
          ),

          // FAB(셔터)와 겹치지 않도록 하단 여백
          const SizedBox(height: 120),
        ],
      ),

      // 가운데 큰 카메라 버튼
      floatingActionButton: SizedBox(
        width: 98,
        height: 98,
        child: FloatingActionButton(
          onPressed: () => nav.goToScanReady(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: const ShutterButton(size: 98),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 하단 네비게이션 바
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    label: '홈',
                    isHome: true,
                    selected: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: _NavItem(
                    label: '리포트',
                    isHome: false,
                    selected: false,
                    onTap: () => nav.goToArchiveCalendar(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 네비게이션 바 내부 아이템 (아이콘 + 라벨)
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.isHome,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool isHome;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.staticBlack : AppColors.stoneGray;

    final String iconPath = isHome
        ? (selected
            ? 'assets/icons/ic_home_on.png'
            : 'assets/icons/ic_home_off.png')
        : (selected
            ? 'assets/icons/ic_report_on.png'
            : 'assets/icons/ic_report_off.png');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage(iconPath),
              width: 28,
              height: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.caption2Regular.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔸 임시 스캔 아이템 모델 (API 연동 시 제거)
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
