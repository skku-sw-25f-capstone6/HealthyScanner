class ScanHistoryResponse {
  final List<ScanHistoryItem> scan;

  ScanHistoryResponse({required this.scan});

  factory ScanHistoryResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['scan'] as List<dynamic>? ?? [])
        .map((e) => ScanHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return ScanHistoryResponse(scan: list);
  }
}

class ScanHistoryItem {
  final String name;
  final String category;
  final String riskLevel;
  final String summary;
  final String url;

  ScanHistoryItem({
    required this.name,
    required this.category,
    required this.riskLevel,
    required this.summary,
    required this.url,
  });

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      riskLevel: json['riskLevel'] ?? 'green',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
