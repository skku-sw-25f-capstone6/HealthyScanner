import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/controller/navigation_controller.dart';
import 'package:healthy_scanner/constants/onboarding_constants.dart';
import 'package:healthy_scanner/data/my_page_info_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<MyPageInfoResponse> fetchMyPageInfo({
    required String jwt,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/myPage/summary');
    final response = await _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $jwt',
        'Accept': 'application/json',
      },
    );

    _handleUnauthorized(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'MyPage summary failed: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return MyPageInfoResponse.fromJson(data);
  }

  Future<void> postOnboardingProfile({
    required String jwt,
    required List<String> habits,
    required List<String> conditions,
    required List<String> allergies,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/users/profile');
    final payload = jsonEncode({
      'habits': habits,
      'conditions': conditions,
      'allergies': allergies,
    });

    try {
      final response = await _client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: payload,
      );

      _handleUnauthorized(response);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Onboarding profile API failed: ${response.statusCode} ${response.body}',
        );
      }

      debugPrint('✅ Onboarding profile uploaded');
    } catch (e) {
      debugPrint('❌ postOnboardingProfile error: $e');
      rethrow;
    }
  }

  Future<HabitUpdateResponse> updateHabit({
    required String jwt,
    required String koreanHabit,
  }) async {
    final englishHabit = OnboardingConstants.habitMap[koreanHabit];
    if (englishHabit == null) {
      throw Exception('Unsupported habit: $koreanHabit');
    }

    final uri = Uri.parse('$baseUrl/v1/me/habits');
    final response = await _client.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode({'habit': englishHabit}),
    );

    _handleUnauthorized(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Habit update failed: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return HabitUpdateResponse.fromJson(data);
  }

  Future<void> updateConditions({
    required String jwt,
    required List<String> koreanConditions,
  }) async {
    final conditionCodes = OnboardingConstants.mapConditions(koreanConditions);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt',
    };
    final body = jsonEncode({'conditions': conditionCodes});
    final response = await _patchWithFallback(
      primaryPath: '/v1/me/conditions',
      fallbackPath: '/v1/me/condition',
      headers: headers,
      body: body,
    );

    _handleUnauthorized(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Condition update failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<void> updateAllergies({
    required String jwt,
    required List<String> koreanAllergies,
  }) async {
    final allergyCodes = OnboardingConstants.mapAllergies(koreanAllergies);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt',
    };
    final body = jsonEncode({'allergies': allergyCodes});
    final response = await _patchWithFallback(
      primaryPath: '/v1/me/allergies',
      fallbackPath: '/v1/me/allergy',
      headers: headers,
      body: body,
    );

    _handleUnauthorized(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Allergy update failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  void _handleUnauthorized(http.Response response) {
    if (response.statusCode != 401) return;

    debugPrint('🔒 Token expired or unauthorized. Forcing logout.');
    final auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : null;

    if (auth != null) {
      auth.logout();
    } else {
      final nav = Get.isRegistered<NavigationController>()
          ? Get.find<NavigationController>()
          : null;
      nav?.goToLogin();
    }

    throw Exception('Unauthorized request: ${response.body}');
  }

  Future<http.Response> _patchWithFallback({
    required String primaryPath,
    String? fallbackPath,
    required Map<String, String> headers,
    required String body,
  }) async {
    final primary = await _client.patch(
      Uri.parse('$baseUrl$primaryPath'),
      headers: headers,
      body: body,
    );

    if (primary.statusCode == 404 && fallbackPath != null) {
      debugPrint('⚠️ $primaryPath not found, trying $fallbackPath');
      return _client.patch(
        Uri.parse('$baseUrl$fallbackPath'),
        headers: headers,
        body: body,
      );
    }

    return primary;
  }
}
