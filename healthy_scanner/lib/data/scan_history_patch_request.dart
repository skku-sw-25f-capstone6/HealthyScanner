class ScanHistoryPatchRequest {
  final String name;
  final String category;

  ScanHistoryPatchRequest({
    required this.name,
    this.category = "Uncategorized",
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
      };
}
