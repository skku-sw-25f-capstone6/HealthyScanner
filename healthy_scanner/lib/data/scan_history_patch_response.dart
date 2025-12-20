class ScanHistoryPatchResponse {
  final String name;
  final String category;
  final DateTime updatedAt;

  ScanHistoryPatchResponse({
    required this.name,
    required this.category,
    required this.updatedAt,
  });

  factory ScanHistoryPatchResponse.fromJson(Map<String, dynamic> json) {
    return ScanHistoryPatchResponse(
      name: (json["name"] ?? "").toString(),
      category: (json["category"] ?? "").toString(),
      updatedAt: DateTime.parse(json["updated_at"].toString()),
    );
  }
}
