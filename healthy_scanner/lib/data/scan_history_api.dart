import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:healthy_scanner/core/api_client.dart';
import 'package:healthy_scanner/data/scan_history_patch_request.dart';
import 'package:healthy_scanner/data/scan_history_patch_response.dart';

class ScanHistoryApi {
  ScanHistoryApi._();

  static Future<ScanHistoryPatchResponse> patchScanHistoryName({
    required String scanId,
    required String accessToken,
    required String requestId,
    required ScanHistoryPatchRequest body,
  }) async {
    try {
      debugPrint('➡️ [PATCH ScanHistory] /v1/scan-history/$scanId');
      debugPrint('🧾 requestId=$requestId');
      debugPrint('🧾 body=${body.toJson()}');

      final res = await ApiClient.dioClient.patch(
        "/v1/scan-history/$scanId",
        data: body.toJson(),
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "X-Request-ID": requestId,
          },
        ),
      );

      debugPrint('✅ [PATCH ScanHistory] status=${res.statusCode}');
      debugPrint('✅ [PATCH ScanHistory] data=${res.data}');

      return ScanHistoryPatchResponse.fromJson(
          res.data as Map<String, dynamic>);
    } on dio.DioException catch (e) {
      debugPrint('❌ [PATCH ScanHistory] DioException');
      debugPrint('🔍 status=${e.response?.statusCode}');
      debugPrint('🔍 responseData=${e.response?.data}');
      debugPrint('🔍 responseHeaders=${e.response?.headers}');
      debugPrint('🔍 requestHeaders=${e.requestOptions.headers}');
      debugPrint('🔍 path=${e.requestOptions.path}');
      debugPrint('🔍 method=${e.requestOptions.method}');
      debugPrint('🔍 requestData=${e.requestOptions.data}');
      rethrow;
    }
  }
}
