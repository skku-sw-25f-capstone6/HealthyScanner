class ScanHistoryDetailResponse {
  final ProductPart product;
  final ScanPart scan;
  final NutritionPart? nutrition;
  final IngredientPart? ingredient;

  ScanHistoryDetailResponse({
    required this.product,
    required this.scan,
    required this.nutrition,
    required this.ingredient,
  });

  factory ScanHistoryDetailResponse.fromJson(Map<String, dynamic> json) {
    return ScanHistoryDetailResponse(
      product: ProductPart.fromJson(
          (json['product'] as Map).cast<String, dynamic>()),
      scan: ScanPart.fromJson((json['scan'] as Map).cast<String, dynamic>()),
      nutrition: (json['nutrition'] == null)
          ? null
          : NutritionPart.fromJson(
              (json['nutrition'] as Map).cast<String, dynamic>()),
      ingredient: (json['ingredient'] == null)
          ? null
          : IngredientPart.fromJson(
              (json['ingredient'] as Map).cast<String, dynamic>()),
    );
  }
}

class ProductPart {
  final String name;
  final String category;
  final String imageUrl;

  ProductPart(
      {required this.name, required this.category, required this.imageUrl});

  factory ProductPart.fromJson(Map<String, dynamic> json) {
    return ProductPart(
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      imageUrl: (json['image_url'] ?? '').toString(),
    );
  }
}

class ScanPart {
  final String summary;
  final int score;
  final ScanReports reports;
  final List<CautionFactor> cautionFactors;

  ScanPart({
    required this.summary,
    required this.score,
    required this.reports,
    required this.cautionFactors,
  });

  factory ScanPart.fromJson(Map<String, dynamic> json) {
    final cf = (json['caution_factors'] as List? ?? [])
        .whereType<Map>()
        .map((e) => CautionFactor.fromJson(e.cast<String, dynamic>()))
        .toList();

    return ScanPart(
      summary: (json['summary'] ?? '').toString(),
      score: (json['score'] is int)
          ? (json['score'] as int)
          : int.tryParse('${json['score']}') ?? 0,
      reports: ScanReports.fromJson(
          (json['reports'] as Map? ?? {}).cast<String, dynamic>()),
      cautionFactors: cf,
    );
  }
}

class ScanReports {
  final ReportBlock? allergies;
  final ReportBlock? condition;
  final List<AlternativeReport> alternatives;
  final ReportBlock? vegan;

  ScanReports({
    required this.allergies,
    required this.condition,
    required this.alternatives,
    required this.vegan,
  });

  factory ScanReports.fromJson(Map<String, dynamic> json) {
    final alt = (json['alternatives'] as List? ?? [])
        .whereType<Map>()
        .map((e) => AlternativeReport.fromJson(e.cast<String, dynamic>()))
        .toList();

    return ScanReports(
      allergies: (json['allergies'] == null)
          ? null
          : ReportBlock.fromJson(
              (json['allergies'] as Map).cast<String, dynamic>()),
      condition: (json['condition'] == null)
          ? null
          : ReportBlock.fromJson(
              (json['condition'] as Map).cast<String, dynamic>()),
      alternatives: alt,
      vegan: (json['vegan'] == null)
          ? null
          : ReportBlock.fromJson(
              (json['vegan'] as Map).cast<String, dynamic>()),
    );
  }
}

class ReportBlock {
  final String briefReport;
  final String face; // "NO" | "NOT_BAD" | "GOOD"
  final String report;

  ReportBlock(
      {required this.briefReport, required this.face, required this.report});

  factory ReportBlock.fromJson(Map<String, dynamic> json) {
    return ReportBlock(
      briefReport: (json['brief_report'] ?? '').toString(),
      face: (json['face'] ?? '').toString(),
      report: (json['report'] ?? '').toString(),
    );
  }
}

class AlternativeReport {
  final String briefReport;
  final String face;
  final String report;

  AlternativeReport(
      {required this.briefReport, required this.face, required this.report});

  factory AlternativeReport.fromJson(Map<String, dynamic> json) {
    return AlternativeReport(
      briefReport: (json['brief_report'] ?? '').toString(),
      face: (json['face'] ?? '').toString(),
      report: (json['report'] ?? '').toString(),
    );
  }
}

class CautionFactor {
  final String factor;
  final String evaluation; // "NO" | "CAUTION" | "OK"

  CautionFactor({required this.factor, required this.evaluation});

  factory CautionFactor.fromJson(Map<String, dynamic> json) {
    return CautionFactor(
      factor: (json['factor'] ?? '').toString(),
      evaluation: (json['evaluation'] ?? '').toString(),
    );
  }
}

class NutritionPart {
  final double? carbsG;
  final double? proteinG;
  final double? sodiumMg;
  final double? sugarG;
  final double? fatG;
  final double? transFatG;
  final double? satFatG;
  final double? cholesterolMg;
  final double? calories;
  final double? perServingGrams;

  NutritionPart({
    this.carbsG,
    this.proteinG,
    this.sodiumMg,
    this.sugarG,
    this.fatG,
    this.transFatG,
    this.satFatG,
    this.cholesterolMg,
    this.calories,
    this.perServingGrams,
  });

  static double? _d(dynamic v) =>
      (v == null) ? null : (v is num ? v.toDouble() : double.tryParse('$v'));

  factory NutritionPart.fromJson(Map<String, dynamic> json) {
    return NutritionPart(
      carbsG: _d(json['carbs_g']),
      proteinG: _d(json['protein_g']),
      sodiumMg: _d(json['sodium_mg']),
      sugarG: _d(json['sugar_g']),
      fatG: _d(json['fat_g']),
      transFatG: _d(json['trans_fat_g']),
      satFatG: _d(json['sat_fat_g']),
      cholesterolMg: _d(json['cholesterol_mg']),
      calories: _d(json['calories']),
      perServingGrams: _d(json['per_serving_grams']),
    );
  }
}

class IngredientPart {
  final String text;
  IngredientPart({required this.text});

  factory IngredientPart.fromJson(Map<String, dynamic> json) {
    return IngredientPart(text: (json['text'] ?? '').toString());
  }
}
