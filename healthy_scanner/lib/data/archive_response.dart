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
  final String scanId;
  final String name;
  final String category;
  final String riskLevel;
  final String summary;
  final String url;

  ScanHistoryItem({
    required this.scanId,
    required this.name,
    required this.category,
    required this.riskLevel,
    required this.summary,
    required this.url,
  });

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    final scanId =
        (json['scanID'] ?? json['scanId'] ?? json['scan_id'] ?? '').toString();

    return ScanHistoryItem(
      scanId: scanId,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      riskLevel: json['riskLevel'] ?? 'green',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
