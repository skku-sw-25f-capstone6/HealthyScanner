import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../component/traffic_light.dart';
import '../../component/food_card.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class AnalysisResultView extends StatefulWidget {
  const AnalysisResultView({super.key});

  @override
  State<AnalysisResultView> createState() => _AnalysisResultViewState();
}

class _AnalysisResultViewState extends State<AnalysisResultView> {
  final controller = Get.find<NavigationController>();

  int selectedTab = 0; // 0: 알레르기 / 1: 건강질환 / 2: 식습관 / 3: 대체 식품
  FoodRecommendation currentState = FoodRecommendation.bad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ 식품 카드
                  Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FoodCard(
                        title: '칸쵸',
                        category: '과자 / 초콜릿가공품',
                        message: '포화지방과 당류가 다소 높고,\n땅콩이 포함되어 있어요.',
                        imageAsset: 'assets/images/cancho.png',
                        warningAsset: 'assets/icons/ic_warning.png',
                        lightState: TrafficLightState.red,
                        onTap: () {},
                      ),
                    ),
                  ),

                  // ✅ AI 리포트
                  Text('AI 리포트',
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.staticBlack)),
                  const SizedBox(height: 10),
                  _buildAIReport(),

                  const SizedBox(height: 28),

                  // ✅ 주의 요소
                  Text('주의 요소',
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.staticBlack)),
                  const SizedBox(height: 10),
                  _buildRiskFactors(),

                  const SizedBox(height: 28),

                  // ✅ 세부 영양성분
                  _buildNutritionFacts(),

                  const SizedBox(height: 32),

                  // ✅ 원재료명
                  Text('원재료명',
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.staticBlack)),
                  const SizedBox(height: 8),
                  Text(
                    '밀가루(미국산), 설탕, 땅콩, 코코아버터, 탈지분유, 유청분말, 팜유, 정제소금 등',
                    style: AppTextStyles.footnote1Regular
                        .copyWith(color: AppColors.charcoleGray, height: 1.5),
                  ),
                ],
              ),
            ),

            // ✅ 뒤로가기
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                // TODO: 뒤로가기 로직 세분화
                // i) 촬영 이후 첫 분석 시 - 메인 화면 (현재는 ScanCropView로 이동함)
                // ii) 리포트>날짜 선택 후 재열람 - 캘린더
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

  // ============================================================
  // ✅ AI 리포트 (탭 포함)
  // ============================================================
  Widget _buildAIReport() {
    final labels = ['알레르기', '건강질환', '식습관 유형', '대체 식품'];
    final contents = [
      '이 제품에는 땅콩, 유제품, 밀 성분이 포함되어 있습니다.\n소량의 혼입만으로도 알레르기 반응이 발생할 수 있습니다.',
      '심혈관 질환이 있는 분은 포화지방 섭취를 줄이는 것이 좋습니다.\n대체로 낮은 지방 간식을 선택하세요.',
      '유제품 허용 채식으로 분류됩니다.\n식습관에 맞는 제품인지 확인해보세요.',
      '견과류나 초콜릿이 없는 대체 간식을 추천드립니다.\n예: 쌀과자, 과일칩, 요거트바 등',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.staticWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryBox(currentState),
          const SizedBox(height: 20),
          // 🔹 탭 버튼
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(labels.length, (index) {
                final isSelected = selectedTab == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedTab = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.mainRed : AppColors.softGray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      labels[index],
                      style: AppTextStyles.footnote1Medium.copyWith(
                        color: isSelected
                            ? AppColors.staticWhite
                            : AppColors.charcoleGray,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            contents[selectedTab],
            style: AppTextStyles.footnote1Regular
                .copyWith(color: AppColors.charcoleGray, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ 총평 박스
  // ============================================================
  Widget _buildSummaryBox(FoodRecommendation state) {
    late Color bgColor;
    late Color iconColor;
    late IconData icon;
    late String message;

    switch (state) {
      case FoodRecommendation.bad:
        bgColor = AppColors.mainRed;
        iconColor = Colors.white;
        icon = Icons.sentiment_very_dissatisfied_rounded;
        message = '땅콩 알레르기와 심혈관 질환이 있는 분께는 비추천드립니다.\n안전한 대체 간식을 선택하시길 권장드립니다.';
        break;
      case FoodRecommendation.caution:
        bgColor = AppColors.kakaoYellow;
        iconColor = AppColors.staticBlack;
        icon = Icons.sentiment_neutral_rounded;
        message = '당류가 다소 높지만, 적정량 섭취 시 괜찮은 간식입니다.\n섭취량에 주의하세요.';
        break;
      case FoodRecommendation.good:
        bgColor = AppColors.mainGreen;
        iconColor = Colors.white;
        icon = Icons.sentiment_satisfied_alt_rounded;
        message = '영양 성분이 균형 잡혀 있어 추천드립니다!';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.footnote1Regular.copyWith(
                color: iconColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ 주의 요소
  // ============================================================
  Widget _buildRiskFactors() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.staticWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRiskRow('유제품 허용 채식', TrafficLightState.yellow,
              icon: Icons.eco_outlined),
          const Divider(color: AppColors.softGray, thickness: 1, height: 20),
          _buildRiskRow('심장질환', TrafficLightState.red,
              icon: Icons.medical_services_outlined),
          const Divider(color: AppColors.softGray, thickness: 1, height: 20),
          _buildRiskRow('땅콩 / 견과류 알레르기', TrafficLightState.yellow,
              icon: Icons.sentiment_dissatisfied_outlined),
        ],
      ),
    );
  }

  Widget _buildRiskRow(String title, TrafficLightState state,
      {IconData icon = Icons.info_outline}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.charcoleGray, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.footnote1Medium
                .copyWith(color: AppColors.staticBlack),
          ),
        ),
        TrafficLight(state: state),
      ],
    );
  }

  // ============================================================
  // ✅ 세부 영양성분 (2줄 구조 + Divider + 정렬 개선)
  // ============================================================
  Widget _buildNutritionFacts() {
    final nutrients = [
      Nutrient(
          name: '탄수화물',
          value: 27,
          unit: 'g',
          daily: 324,
          baseColor: AppColors.staticBlack),
      Nutrient(
          name: '단백질',
          value: 15,
          unit: 'g',
          daily: 55,
          baseColor: AppColors.staticBlack),
      Nutrient(
          name: '나트륨',
          value: 105,
          unit: 'mg',
          daily: 2000,
          baseColor: AppColors.staticBlack),
      Nutrient(name: '당류', value: 15, unit: 'g', daily: 50),
      Nutrient(name: '지방', value: 9, unit: 'g', daily: 54),
      Nutrient(name: '트랜스지방', value: 0, unit: 'g', daily: 2),
      Nutrient(name: '포화지방', value: 5, unit: 'g', daily: 15),
      Nutrient(name: '콜레스테롤', value: 2, unit: 'mg', daily: 300),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('세부 영양성분',
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.staticBlack)),
            Text('40g / 200kcal',
                style: AppTextStyles.caption1Regular
                    .copyWith(color: AppColors.brownGray)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.staticWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(nutrients.length, (i) {
              final n = nutrients[i];
              final percent =
                  (n.value / n.daily * 100).clamp(0, 100).toDouble();
              final isOver = percent > 20;
              final barColor = (n.baseColor != null)
                  ? n.baseColor!
                  : isOver
                      ? AppColors.mainRed
                      : AppColors.mainGreen;

              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기준치 바
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(n.name,
                                style: AppTextStyles.footnote1Medium
                                    .copyWith(color: AppColors.staticBlack)),
                          ),
                          Expanded(
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.softGray,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${percent.toStringAsFixed(0)}%',
                            style: AppTextStyles.caption1Regular
                                .copyWith(color: AppColors.brownGray),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // 실제 함유량 바
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 70),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (percent / 100).clamp(0.0, 1.0),
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${n.value}${n.unit}',
                              style: AppTextStyles.footnote1Medium.copyWith(
                                  color: barColor,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  if (i != nutrients.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(
                          color: AppColors.softGray, thickness: 1, height: 1),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ENUM & MODEL
// ============================================================
enum FoodRecommendation { bad, caution, good }

class Nutrient {
  final String name;
  final double value;
  final String unit;
  final double daily;
  final Color? baseColor;

  Nutrient({
    required this.name,
    required this.value,
    required this.unit,
    required this.daily,
    this.baseColor,
  });
}
