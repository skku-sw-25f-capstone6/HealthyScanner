import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/component/food_card.dart';
import 'package:healthy_scanner/controller/archive_controller.dart';
import 'package:healthy_scanner/component/traffic_light.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';

class ArchiveListView extends StatelessWidget {
  final DateTime selectedDate;
  ArchiveListView({super.key, required this.selectedDate});

  String _prettyKoreanDate(DateTime d) => '${d.year}년 ${d.month}월 ${d.day}일';

  final NavigationController _nav = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ArchiveListController())..load(selectedDate);

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.delete<ArchiveListController>();
                            Navigator.of(context).maybePop();
                          },
                          child: Image.asset(
                            'assets/icons/ic_chevron_left.png',
                            width: 29,
                            height: 29,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '스캔 기록',
                              style: context.bodyMedium.copyWith(
                                color: AppColors.staticBlack,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                    const SizedBox(height: 19),
                    Obx(() => Text(
                          _prettyKoreanDate(c.selectedDate.value),
                          style: context.footnote2Medium.copyWith(
                            color: AppColors.staticBlack,
                          ),
                        )),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: Obx(() {
                if (c.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: AppColors.brownGray,
                      )),
                    ),
                  );
                }

                if (c.errorMessage.value.isNotEmpty) {
                  debugPrint("❌ Failed to make list");
                  debugPrint(c.errorMessage.string);

                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          '기록을 불러오지 못했어요.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                if (c.items.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text('해당 날짜의 스캔 기록이 없어요.')),
                    ),
                  );
                }

                return SliverList.separated(
                  itemCount: c.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final it = c.items[index];
                    return FoodCard(
                      title: it.name,
                      category: it.category,
                      message: it.summary,
                      imageAsset: it.url,
                      warningAsset: 'assets/icons/ic_warning.png',
                      lightState: riskToState(it.riskLevel),
                      onTap: () {
                        final scanId = it.scanId;
                        debugPrint('🖱️ [Archive] tapped scanId=$scanId');
                        if (scanId.isEmpty) return;

                        _nav.goToAnalysisResult(scanId: scanId);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

TrafficLightState riskToState(String riskLevel) {
  switch (riskLevel.toLowerCase()) {
    case 'red':
      return TrafficLightState.red;
    case 'yellow':
      return TrafficLightState.yellow;
    case 'green':
    default:
      return TrafficLightState.green;
  }
}
