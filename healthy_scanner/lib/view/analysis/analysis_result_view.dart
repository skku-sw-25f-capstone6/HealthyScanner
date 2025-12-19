import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/navigation_controller.dart';
import '../../component/traffic_light.dart';
import '../../component/food_card.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'package:healthy_scanner/controller/analysis_result_controller.dart';
import 'package:healthy_scanner/data/scan_history_detail_response.dart';
import 'package:healthy_scanner/core/url_resolver.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/constants/onboarding_constants.dart';

class AnalysisResultView extends StatefulWidget {
  const AnalysisResultView({super.key});

  @override
  State<AnalysisResultView> createState() => _AnalysisResultViewState();
}

class _AnalysisResultViewState extends State<AnalysisResultView> {
  final nav = Get.find<NavigationController>();
  final result = Get.put(AnalysisResultController());

  int selectedTab = 0; // 0: 알레르기 / 1: 건강질환 / 2: 식습관 / 3: 대체 식품

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              // 로딩
              if (result.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainRed,
                  ),
                );
              }

              // 에러
              final err = result.error.value;
              if (err != null) {
                return _buildError(err);
              }

              // 데이터
              final data = result.detail.value;
              if (data == null) {
                return _buildError('데이터가 비어있어요.');
              }

              final raw = data.product.imageUrl;
              final imageUrl = UrlResolver.resolve('healthy-scanner.com', raw);

              return _buildContent(context, data, imageUrl);
            }),

            // ✅ 뒤로가기
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: nav.goBack,
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

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "정보를 불러올 수 없어요",
              style: context.bodyMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: result.fetch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.peachRed,
                foregroundColor: AppColors.mainRed,
                textStyle: context.bodyBold,
              ),
              child: const Text('다시 시도하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ScanHistoryDetailResponse data,
    String imageUrl,
  ) {
    final product = data.product;
    final scan = data.scan;

    final foodState = _scoreToFoodRecommendation(scan.score);
    final lightState = _scoreToTrafficLight(scan.score);

    // AI 리포트 탭 데이터 구성
    final labels = ['알레르기', '건강질환', '식습관 유형'];
    final contents = [
      _reportText(scan.reports.allergies),
      _reportText(scan.reports.condition),
      _reportText(scan.reports.vegan),
    ];

    // 주의 요소 (caution_factors)
    final cautionList = scan.cautionFactors;

    return SingleChildScrollView(
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
                title: product.name.isEmpty ? '식품' : product.name,
                category: product.category.isEmpty ? '카테고리' : product.category,
                message: scan.summary.isEmpty ? '분석 요약이 없어요.' : scan.summary,
                imageAsset: imageUrl,
                warningAsset: (lightState == TrafficLightState.red)
                    ? 'assets/icons/ic_warning.png'
                    : null,
                lightState: lightState,
                onTap: () {},
              ),
            ),
          ),

          // ✅ AI 리포트
          Text(
            'AI 리포트',
            style:
                AppTextStyles.bodyBold.copyWith(color: AppColors.staticBlack),
          ),
          const SizedBox(height: 10),
          _buildAIReport(
            labels: labels,
            contents: contents,
            foodState: foodState,
            score: scan.score,
          ),

          const SizedBox(height: 28),

          // ✅ 주의 요소 (API)
          Text(
            '주의 요소',
            style:
                AppTextStyles.bodyBold.copyWith(color: AppColors.staticBlack),
          ),
          const SizedBox(height: 10),
          _buildRiskFactorsFromApi(cautionList),

          const SizedBox(height: 28),

          // ✅ 세부 영양성분 (API)
          if (data.nutrition != null)
            _buildNutritionFactsFromApi(data.nutrition!),

          const SizedBox(height: 32),

          // ✅ 원재료명 (API)
          Text(
            '원재료명',
            style:
                AppTextStyles.bodyBold.copyWith(color: AppColors.staticBlack),
          ),
          const SizedBox(height: 8),
          Text(
            (data.ingredient?.text.trim().isNotEmpty == true)
                ? data.ingredient!.text
                : '원재료 정보가 없어요.',
            style: AppTextStyles.footnote1Regular
                .copyWith(color: AppColors.charcoleGray, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ AI 리포트 (탭 포함) - API 바인딩 버전
  // ============================================================
  Widget _buildAIReport({
    required List<String> labels,
    required List<String> contents,
    required FoodRecommendation foodState,
    required int score,
  }) {
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
          _buildSummaryBox(foodState, score),
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
  // ✅ 총평 박스 (점수 기반)
  // ============================================================
  Widget _buildSummaryBox(FoodRecommendation state, int score) {
    late Color bgColor;
    late Color iconColor;
    late IconData icon;
    late String message;

    switch (state) {
      case FoodRecommendation.bad:
        bgColor = AppColors.mainRed;
        iconColor = Colors.white;
        icon = Icons.sentiment_very_dissatisfied_rounded;
        message = '점수 $score점\n섭취를 추천드리지 않아요.';
        break;
      case FoodRecommendation.caution:
        bgColor = AppColors.kakaoYellow;
        iconColor = AppColors.staticBlack;
        icon = Icons.sentiment_neutral_rounded;
        message = '점수 $score점\n섭취량을 조절하여 섭취하세요.';
        break;
      case FoodRecommendation.good:
        bgColor = AppColors.mainGreen;
        iconColor = Colors.white;
        icon = Icons.sentiment_satisfied_alt_rounded;
        message = '점수 $score점\n추천드릴만한 좋은 식품이에요.';
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
  // ✅ 주의 요소 (API: caution_factors)
  // ============================================================
  Widget _buildRiskFactorsFromApi(List<CautionFactor> items) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Text(
          '주의 요소가 없어요.',
          style: AppTextStyles.footnote1Regular
              .copyWith(color: AppColors.charcoleGray),
        ),
      );
    }

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
        children: List.generate(items.length, (i) {
          final it = items[i];
          final state = _evaluationToTrafficLight(it.evaluation);
          final label = _cautionFactorToKorean(it.factor);

          return Column(
            children: [
              _buildRiskRow(label, state),
              if (i != items.length - 1)
                const Divider(
                    color: AppColors.softGray, thickness: 1, height: 20),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRiskRow(String title, TrafficLightState state,
      {IconData icon = Icons.warning_rounded}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.mainRed, size: 22),
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
  // ✅ 세부 영양성분 (API nutrition)
  // ============================================================
  Widget _buildNutritionFactsFromApi(NutritionPart nutrition) {
    final perServing = nutrition.perServingGrams;
    final calories = nutrition.calories;

    final nutrients = [
      _NutrientVM(name: '탄수화물', value: nutrition.carbsG, unit: 'g', daily: 324),
      _NutrientVM(name: '단백질', value: nutrition.proteinG, unit: 'g', daily: 55),
      _NutrientVM(
          name: '나트륨', value: nutrition.sodiumMg, unit: 'mg', daily: 2000),
      _NutrientVM(name: '당류', value: nutrition.sugarG, unit: 'g', daily: 50),
      _NutrientVM(name: '지방', value: nutrition.fatG, unit: 'g', daily: 54),
      _NutrientVM(
          name: '트랜스지방', value: nutrition.transFatG, unit: 'g', daily: 2),
      _NutrientVM(name: '포화지방', value: nutrition.satFatG, unit: 'g', daily: 15),
      _NutrientVM(
          name: '콜레스테롤',
          value: nutrition.cholesterolMg,
          unit: 'mg',
          daily: 300),
    ];

    String servingText;
    if (perServing != null && calories != null) {
      servingText =
          '${perServing.toStringAsFixed(0)}g / ${calories.toStringAsFixed(0)}kcal';
    } else if (perServing != null) {
      servingText = '${perServing.toStringAsFixed(0)}g';
    } else if (calories != null) {
      servingText = '${calories.toStringAsFixed(0)}kcal';
    } else {
      servingText = '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '세부 영양성분',
              style:
                  AppTextStyles.bodyBold.copyWith(color: AppColors.staticBlack),
            ),
            if (servingText.isNotEmpty)
              Text(
                servingText,
                style: AppTextStyles.caption1Regular
                    .copyWith(color: AppColors.brownGray),
              ),
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

              final value = n.value ?? 0;
              final percent = (n.daily <= 0)
                  ? 0.0
                  : ((value / n.daily) * 100).clamp(0, 100).toDouble();

              final isOver = percent > 20;
              final barColor = isOver ? AppColors.mainRed : AppColors.mainGreen;

              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기준치 바(회색) + %
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              n.name,
                              style: AppTextStyles.footnote1Medium
                                  .copyWith(color: AppColors.staticBlack),
                            ),
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

                      // 실제 함유량 바 + 값
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
                          Text(
                            n.value == null ? '-' : '${_fmt(n.value)}${n.unit}',
                            style: AppTextStyles.footnote1Medium.copyWith(
                              color: barColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (i != nutrients.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(
                        color: AppColors.softGray,
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // helpers
  // ============================================================
  FoodRecommendation _scoreToFoodRecommendation(int score) {
    if (score < 35) return FoodRecommendation.bad;
    if (score < 70) return FoodRecommendation.caution;
    return FoodRecommendation.good;
  }

  TrafficLightState _scoreToTrafficLight(int score) {
    if (score < 35) return TrafficLightState.red;
    if (score < 70) return TrafficLightState.yellow;
    return TrafficLightState.green;
  }

  TrafficLightState _evaluationToTrafficLight(String evaluation) {
    switch (evaluation) {
      case 'NO':
        return TrafficLightState.red;
      case 'OK':
        return TrafficLightState.green;
      case 'CAUTION':
      default:
        return TrafficLightState.yellow;
    }
  }

  String _reportText(ReportBlock? block) {
    if (block == null) return '분석된 리포트가 없어요.';
    final brief = block.briefReport.trim();
    final report = block.report.trim();

    if (brief.isEmpty && report.isEmpty) return '분석된 리포트가 없어요.';
    if (brief.isEmpty) return report;
    if (report.isEmpty) return brief;

    // brief_report는 보여주지 않도록 삭제
    return report;
  }

  String _fmt(double? v) {
    if (v == null) return '-';
    final s = v.toString();
    if (s.endsWith('.0')) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  String _cautionFactorToKorean(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return '주의 요소';

    // 서버가 peanut_allergy / wheat_allergy 같은 형태로 줄 때
    if (s.endsWith('_allergy')) {
      final code = s.replaceAll('_allergy', '');
      final ko = OnboardingConstants.allergyCodeToLabel(code) ??
          _fallbackAllergyKo(code);
      return '$ko 알레르기';
    }

    // 1) 질환 코드 (hypertension 등)
    final conditionKo = OnboardingConstants.conditionCodeToLabel(s);
    if (conditionKo != null) return conditionKo;

    // 2) 알레르기 코드 (wheat, soy 등)
    final allergyKo = OnboardingConstants.allergyCodeToLabel(s);
    if (allergyKo != null) return '$allergyKo 알레르기';

    // 3) 영양/기타 주의 요소 (high_fat 등)
    const otherMap = <String, String>{
      'high_fat': '지방 함량이 높아요',
      'high_sugar': '당류 함량이 높아요',
      'high_sodium': '나트륨 함량이 높아요',
      'high_calorie': '칼로리가 높아요',
      'high_sat_fat': '포화지방 함량이 높아요',
      'high_trans_fat': '트랜스지방 함량이 높아요',
      'high_cholesterol': '콜레스테롤 함량이 높아요',
    };
    final other = otherMap[s];
    if (other != null) return other;

    return s.replaceAll('_', ' ');
  }

  String _fallbackAllergyKo(String code) {
    switch (code) {
      case 'peanut':
        return '땅콩';
      case 'nut':
        return '견과류';
      default:
        return code; // 알 수 없으면 원문
    }
  }
}

enum FoodRecommendation { bad, caution, good }

class _NutrientVM {
  final String name;
  final double? value;
  final String unit;
  final double daily;

  _NutrientVM({
    required this.name,
    required this.value,
    required this.unit,
    required this.daily,
  });
}
