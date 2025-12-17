import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthy_scanner/data/home_response.dart';

class HomeApi {
  HomeApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<HomeResponse> fetchHome({
    required String jwt,
    required String requestId,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/home');

    final res = await _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $jwt',
        'Accept': 'application/json',
        'X-Request-ID': requestId,
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Home API failed: ${res.statusCode} ${res.body}');
    }

    debugPrint('HOME RAW BODY: ${res.body}');

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return HomeResponse.fromJson(data);
  }
}
