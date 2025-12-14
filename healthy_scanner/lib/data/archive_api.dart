import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:healthy_scanner/data/archive_response.dart';
import 'package:http/http.dart' as http;

Future<List<ScanHistoryItem>> fetchScanHistory({
  required String baseHost,
  required DateTime date,
  required String jwt,
}) async {
  final dateStr =
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  final uri = Uri.https(
    baseHost,
    '/v1/scan-history',
    {'date': dateStr},
  );

  final resp = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $jwt',
      'Accept': 'application/json',
      'X-Request-ID': const Uuid().v4(),
    },
  );

  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    throw Exception('scan-history failed: ${resp.statusCode} ${resp.body}');
  }

  final jsonMap = jsonDecode(resp.body) as Map<String, dynamic>;
  final parsed = ScanHistoryResponse.fromJson(jsonMap);
  return parsed.scan;
}
