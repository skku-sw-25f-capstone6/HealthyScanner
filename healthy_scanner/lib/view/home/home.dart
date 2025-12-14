import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/controller/home_controller.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/food_card.dart';
import 'package:healthy_scanner/view/home/home_progress_bar.dart';
import 'package:healthy_scanner/view/home/home_curved_clipper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();
    final home = Get.find<HomeController>();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.mainRed,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.staticWhite,
      extendBody: true,
      body: Obx(() {
        final score = home.todayScore.value;
        final items = home.scanItems;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipPath(
              clipper: BottomArcClipper(arcHeight: 25),
              child: Container(
                color: AppColors.mainRed,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).padding.top,
                      color: AppColors.mainRed,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () => nav.goToMyPage(),
                                child: const Image(
                                  image:
                                      AssetImage('assets/icons/ic_mypage.png'),
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 180,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SemiCircularProgress(
                                  value: (score / 100.0).clamp(0.0, 1.0),
                                  size: 224,
                                  thickness: 12,
                                  offsetY: 50,
                                  bgColor: const Color(0x33FFFFFF),
                                  fgColor: AppColors.staticWhite,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$score',
                                      style: context.largeTitle.copyWith(
                                          color: AppColors.staticWhite),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '오늘의 찍먹 점수',
                                      style: context.footnote2Medium.copyWith(
                                          color: AppColors.staticWhite),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      '${DateTime.now().month}월 ${DateTime.now().day}일',
                                      style: context.bodyMedium.copyWith(
                                          color: AppColors.staticWhite),
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
                decoration: const BoxDecoration(gradient: AppColors.linearGray),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 27, 12, 0),
                  child: Column(
                    children: [
                      if (home.isLoading.value) ...[
                        const SizedBox(height: 20),
                        const Center(child: CircularProgressIndicator()),
                      ] else if (home.errorMessage.value != null) ...[
                        Text(
                          "정보를 불러올 수 없어요",
                          style: context.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: home.fetchHome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.peachRed,
                            foregroundColor: AppColors.mainRed,
                            textStyle: context.bodyBold,
                          ),
                          child: const Text('다시 시도하기'),
                        ),
                      ] else ...[
                        if (items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Column(
                              children: [
                                Text(
                                  '최근 찍먹 기록이 없네요.',
                                  style: context.bodyMedium.copyWith(
                                    color: AppColors.stoneGray,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '식품을 스캔해 볼까요?',
                                  style: context.body2Bold.copyWith(
                                    color: AppColors.stoneGray,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 50),
                                ElevatedButton(
                                  onPressed: () =>
                                      Get.find<NavigationController>()
                                          .goToScanReady(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.peachRed,
                                    foregroundColor: AppColors.mainRed,
                                    textStyle: context.bodyBold,
                                  ),
                                  child: const Text('스캔 시작하기'),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          FoodCard(
                            title: items[0].name,
                            category: items[0].category,
                            message: items[0].summary,
                            imageAsset: items[0].url,
                            warningAsset: 'assets/icons/ic_warning.png',
                            lightState: items[0].riskLevel,
                            onTap: () {},
                          ),
                          const SizedBox(height: 15),
                          if (items.length > 1)
                            FoodCard(
                              title: items[1].name,
                              category: items[1].category,
                              message: items[1].summary,
                              imageAsset: items[1].url,
                              warningAsset: 'assets/icons/ic_warning.png',
                              lightState: items[1].riskLevel,
                              onTap: () {},
                            ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
