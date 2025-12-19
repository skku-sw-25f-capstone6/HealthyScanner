class OnboardingConstants {
  OnboardingConstants._();

  static const String defaultDietLabel = '일반식';
  static const String noDiseaseLabel = '건강 질환이 없어요';
  static const String noAllergyLabel = '없어요';

  static const Map<String, String> habitMap = {
    '일반식': 'regular',
    '생선 채식': 'pescatarian',
    '유제품 허용 채식': 'lactoVegetarian',
    '달걀 허용 채식': 'ovoVegetarian',
    '채식': 'vegan',
  };

  static const Map<String, String> conditionMap = {
    '고혈압': 'hypertension',
    '간질환': 'liverDisease',
    '통풍': 'gout',
    '당뇨병': 'diabetes',
    '고지혈증': 'hyperlipidemia',
    '신장질환': 'kidneyDisease',
    '갑상선질환': 'thyroidDisease',
  };

  static const Map<String, String> allergyMap = {
    '갑각류': 'crustacean',
    '밀': 'wheat',
    '조개류': 'shellfish',
    '새우': 'shrimp',
    '유제품': 'dairy',
    '소고기': 'beef',
    '견과류': 'nut',
    '복숭아': 'peach',
    '계란': 'egg',
    '사과': 'apple',
    '파인애플': 'pineapple',
    '생선': 'fish',
    '대두(콩)': 'soy',
    '땅콩': 'peanut',
  };

  static const Map<String, String> _conditionCodeToLabel = {
    'hypertension': '고혈압',
    'liverDisease': '간질환',
    'gout': '통풍',
    'diabetes': '당뇨병',
    'hyperlipidemia': '고지혈증',
    'kidneyDisease': '신장질환',
    'thyroidDisease': '갑상선질환',
  };

  static const Map<String, String> _allergyCodeToLabel = {
    'crustacean': '갑각류',
    'wheat': '밀',
    'shellfish': '조개류',
    'shrimp': '새우',
    'dairy': '유제품',
    'beef': '소고기',
    'nut': '견과류',
    'peanut': '견과류',
    'peach': '복숭아',
    'egg': '계란',
    'apple': '사과',
    'pineapple': '파인애플',
    'fish': '생선',
    'soy': '대두(콩)',
  };

  static List<String> mapHabit(String? selectedHabit) {
    final key = (selectedHabit == null || selectedHabit.isEmpty)
        ? defaultDietLabel
        : selectedHabit;
    final resolved = habitMap[key];
    if (resolved == null) return [];
    return [resolved];
  }

  static String? habitCodeToLabel(String? code) {
    if (code == null || code.isEmpty) return null;
    for (final entry in habitMap.entries) {
      if (entry.value == code) return entry.key;
    }
    return null;
  }

  static List<String> mapConditions(List<String> selectedConditions) {
    return selectedConditions
        .where((condition) => condition != noDiseaseLabel)
        .map((condition) => conditionMap[condition])
        .whereType<String>()
        .toList();
  }

  static List<String> conditionCodesToLabels(List<String>? codes) {
    if (codes == null) return [];
    return codes
        .map((code) => _conditionCodeToLabel[code])
        .whereType<String>()
        .toList();
  }

  static List<String> mapAllergies(List<String> selectedAllergies) {
    return selectedAllergies
        .where((allergy) => allergy != noAllergyLabel)
        .map((allergy) => allergyMap[allergy])
        .whereType<String>()
        .toList();
  }

  static List<String> allergyCodesToLabels(List<String>? codes) {
    if (codes == null) return [];
    return codes
        .map((code) => _allergyCodeToLabel[code])
        .whereType<String>()
        .toList();
  }

  static String? conditionCodeToLabel(String? code) {
    if (code == null || code.isEmpty) return null;
    return _conditionCodeToLabel[code];
  }

  static String? allergyCodeToLabel(String? code) {
    if (code == null || code.isEmpty) return null;
    return _allergyCodeToLabel[code];
  }
}
