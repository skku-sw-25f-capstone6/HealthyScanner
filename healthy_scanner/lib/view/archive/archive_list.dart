import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/component/traffic_light.dart';
import 'package:healthy_scanner/component/food_card.dart';

class ArchiveListView extends StatelessWidget {
  const ArchiveListView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 임시 리스트 (API 연결 필요)
    final items = List<_FoodItem>.generate(
      5,
      (i) => _FoodItem(
        title: '칸쵸',
        category: '과자/초콜릿가공품',
        message: '포화지방과 당류가 다소 높고,\n땅콩이 포함되어 있어요.',
        imageAsset: 'assets/images/cancho.png',
        lightState: TrafficLightState.red,
        warningAsset: 'assets/icons/ic_warning.png',
      ),
    );

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
                    // 뒤로가기 + 제목
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
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
                    Text('2025년 10월 6일',
                        style: context.footnote2Medium
                            .copyWith(color: AppColors.staticBlack)),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),

            // 카드 리스트
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
                      // TODO: 상세 페이지로 이동
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: 임시 아이템 모델 (API 연결 시 제거)
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
