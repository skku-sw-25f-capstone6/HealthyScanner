class MyPageInfoResponse {
  const MyPageInfoResponse({
    required this.name,
    required this.scanCount,
    required this.profileImageUrl,
    this.habit,
    this.conditions = const [],
    this.allergies = const [],
  });

  final String name;
  final int scanCount;
  final String profileImageUrl;
  final String? habit;
  final List<String> conditions;
  final List<String> allergies;

  factory MyPageInfoResponse.fromJson(Map<String, dynamic> json) {
    final normalized = _extractUserPayload(json);
    return MyPageInfoResponse(
      name: _extractCleanString(normalized['name']) ?? '',
      scanCount: (normalized['scan_count'] ?? 0) as int,
      profileImageUrl:
          _extractCleanString(normalized['profile_image_url']) ?? '',
      habit: _extractPrimaryString(normalized['habit']),
      conditions: _extractStringList(normalized['conditions']),
      allergies: _extractStringList(normalized['allergies']),
    );
  }

  static Map<String, dynamic> _extractUserPayload(
    Map<String, dynamic> raw,
  ) {
    // NOTE: /v1/myPage/summary sometimes nests user metadata under `user`,
    // but numeric stats(e.g., scan_count) stay on the root. We merge both maps
    // so UI always sees a complete snapshot regardless of backend shape.
    final merged = Map<String, dynamic>.from(raw);
    final user = raw['user'];
    if (user is Map<String, dynamic>) {
      merged.addAll(user);
    }
    return merged;
  }

  static String? _extractCleanString(dynamic value) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || trimmed.toLowerCase() == 'none') return null;
      return trimmed;
    }
    return null;
  }

  static String? _extractPrimaryString(dynamic value) {
    if (value is String) {
      final clean = _extractCleanString(value);
      if (clean != null) return clean;
    }
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is String) return first;
      return first?.toString();
    }
    return null;
  }

  static List<String> _extractStringList(dynamic value) {
    if (value is List) {
      return value
          .map((e) => e?.toString())
          .whereType<String>()
          .toList();
    }
    if (value is String && value.isNotEmpty) {
      return [value];
    }
    return [];
  }
}

class HabitUpdateResponse {
  const HabitUpdateResponse({
    required this.habit,
    required this.updatedAt,
  });

  final String habit;
  final DateTime? updatedAt;

  factory HabitUpdateResponse.fromJson(Map<String, dynamic> json) {
    final updated = json['updated_at'] as String?;
    return HabitUpdateResponse(
      habit: (json['habit'] ?? '') as String,
      updatedAt: updated != null ? DateTime.tryParse(updated) : null,
    );
  }
}
