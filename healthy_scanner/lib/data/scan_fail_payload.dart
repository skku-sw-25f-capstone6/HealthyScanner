class ScanFailPayload {
  final String title;
  final String message;
  final bool forceLogout; // 401이면 true
  final bool suggestIngredientMode; // 404이면 true

  const ScanFailPayload({
    required this.title,
    required this.message,
    this.forceLogout = false,
    this.suggestIngredientMode = false,
  });

  Map<String, dynamic> toArgs() => {
        'title': title,
        'message': message,
        'forceLogout': forceLogout,
        'suggestIngredientMode': suggestIngredientMode,
      };

  factory ScanFailPayload.fromArgs(Map<String, dynamic>? args) {
    return ScanFailPayload(
      title: (args?['title'] as String?) ?? '오류가 발생했어요',
      message: (args?['message'] as String?) ?? '사진을 다시 촬영해 주세요',
      forceLogout: (args?['forceLogout'] as bool?) ?? false,
      suggestIngredientMode: (args?['suggestIngredientMode'] as bool?) ?? false,
    );
  }
}
