import 'package:healthy_scanner/component/traffic_light.dart';

class HomeResponse {
  final int todayScore;
  final List<ScanItem> scan;

  HomeResponse({
    required this.todayScore,
    required this.scan,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      todayScore: (json['todayScore'] ?? 0) as int,
      scan: (json['scan'] as List<dynamic>? ?? [])
          .map((e) => ScanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ScanItem {
  final String name;
  final String category;
  final TrafficLightState riskLevel;
  final String summary;
  final String url;

  ScanItem({
    required this.name,
    required this.category,
    required this.riskLevel,
    required this.summary,
    required this.url,
  });

  factory ScanItem.fromJson(Map<String, dynamic> json, {int? index}) {
    final rawName = json['name'] as String?;
    final rawCategory = json['category'] as String?;
    final level = (json['riskLevel'] ?? 'green').toString().toLowerCase();

    return ScanItem(
      name: (rawName == null || rawName.trim().isEmpty)
          ? '식품${index != null ? ' ${index + 1}' : ''}'
          : rawName,
      category: (rawCategory == null || rawCategory.trim().isEmpty)
          ? '카테고리'
          : rawCategory,
      riskLevel: _toTrafficLightState(level),
      summary: (json['summary'] ?? '') as String,
      url: (json['url'] ?? '') as String,
    );
  }

  static TrafficLightState _toTrafficLightState(String level) {
    switch (level) {
      case 'red':
        return TrafficLightState.red;
      case 'yellow':
        return TrafficLightState.yellow;
      case 'green':
      default:
        return TrafficLightState.green;
    }
  }
}
