import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide Response, FormData;
import 'package:healthy_scanner/controller/auth_controller.dart';
import 'package:healthy_scanner/data/scan_history_detail_response.dart';
import 'dart:convert';

class ScanAnalyzeResponse {
  final String scanId;
  final String? productId;
  final String? nutritionId;
  final String? ingredientId;

  ScanAnalyzeResponse({
    required this.scanId,
    this.productId,
    this.nutritionId,
    this.ingredientId,
  });

  factory ScanAnalyzeResponse.fromJson(Map<String, dynamic> json) {
    final scanId = json['scan_id']?.toString();
    if (scanId == null || scanId.isEmpty) {
      throw Exception('Missing scan_id in response: $json');
    }

    return ScanAnalyzeResponse(
      scanId: scanId,
      productId: json['product_id']?.toString(),
      nutritionId: json['nutrition_id']?.toString(),
      ingredientId: json['ingredient_id']?.toString(),
    );
  }
}

class ScanApi {
  final dio.Dio _dio;
  final Uuid _uuid = const Uuid();

  ScanApi({
    required dio.Dio dioClient,
  }) : _dio = dioClient;

  Future<dio.Response<dynamic>> _postWithManualRefreshRetry({
    required String path,
    required String jwt,
    required String requestId,
    required dio.FormData Function() buildFormData,
    required String logTag,
  }) async {
    Future<dio.Response<dynamic>> call(String token, {required bool retried}) {
      return _dio.post(
        path,
        data: buildFormData(),
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'X-Request-ID': requestId,
          },
          extra: {
            'skipRefresh': true,
            '__scanApiRetried': retried,
          },
        ),
      );
    }

    try {
      return await call(jwt, retried: false);
    } on dio.DioException catch (e) {
      debugPrint('❌ [$logTag]');
      debugPrint('🔍 status: ${e.response?.statusCode}');
      debugPrint('🔍 data: ${e.response?.data}');
      debugPrint('🔍 headers: ${e.response?.headers}');
      debugPrint('🔍 type: ${e.type}');

      final status = e.response?.statusCode;
      final alreadyRetried =
          (e.requestOptions.extra['__scanApiRetried'] == true);

      if (status == 401 && !alreadyRetried) {
        final auth = Get.find<AuthController>();
        final newToken = await auth.refreshAppToken();

        if (newToken == null || newToken.isEmpty) {
          rethrow;
        }

        try {
          return await call(newToken, retried: true);
        } on dio.DioException catch (e2) {
          debugPrint('❌ [$logTag] retry failed');
          debugPrint('🔁 status: ${e2.response?.statusCode}');
          debugPrint('🔁 data: ${e2.response?.data}');
          rethrow;
        }
      }

      rethrow;
    }
  }

  Future<ScanAnalyzeResponse> analyzeBarcodeImage({
    required String jwt,
    required Uint8List imageBytes,
    String? barcode,
  }) async {
    final requestId = _uuid.v4();

    dio.FormData build() {
      return dio.FormData.fromMap({
        if (barcode != null && barcode.trim().isNotEmpty)
          'barcode': barcode.trim(),
        'image': dio.MultipartFile.fromBytes(
          imageBytes,
          filename: 'scan.jpg',
          contentType: dio.DioMediaType.parse('image/jpeg'),
        ),
      });
    }

    final res = await _postWithManualRefreshRetry(
      path: '/v1/scan/barcode_image',
      jwt: jwt,
      requestId: requestId,
      buildFormData: build,
      logTag: 'Barcode API',
    );

    return _parseScanAnalyzeResponse(res);
  }

  Future<ScanAnalyzeResponse> analyzeNutritionLabel({
    required String jwt,
    required Uint8List imageBytes,
    required String nutritionLabel,
  }) async {
    final requestId = _uuid.v4();

    dio.FormData build() {
      return dio.FormData.fromMap({
        'nutrition_label': nutritionLabel,
        'image': dio.MultipartFile.fromBytes(
          imageBytes,
          filename: 'scan.jpg',
          contentType: dio.DioMediaType.parse('image/jpeg'),
        ),
      });
    }

    final res = await _postWithManualRefreshRetry(
      path: '/v1/scan/nutrition_label',
      jwt: jwt,
      requestId: requestId,
      buildFormData: build,
      logTag: 'NutritionLabel API',
    );

    return _parseScanAnalyzeResponse(res);
  }

  Future<ScanAnalyzeResponse> analyzeImageOnly({
    required String jwt,
    required Uint8List imageBytes,
  }) async {
    final requestId = _uuid.v4();

    dio.FormData build() {
      return dio.FormData.fromMap({
        'image': dio.MultipartFile.fromBytes(
          imageBytes,
          filename: 'scan.jpg',
          contentType: dio.DioMediaType.parse('image/jpeg'),
        ),
      });
    }

    final res = await _postWithManualRefreshRetry(
      path: '/v1/scan/image',
      jwt: jwt,
      requestId: requestId,
      buildFormData: build,
      logTag: 'ImageOnly API',
    );

    return _parseScanAnalyzeResponse(res);
  }

  ScanAnalyzeResponse _parseScanAnalyzeResponse(dio.Response res) {
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw dio.DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: dio.DioExceptionType.badResponse,
        message: 'Analyze failed: ${res.statusCode}',
      );
    }

    final data = res.data;
    debugPrint('✅ [API] analyze success raw body: $data');

    if (data is! Map) {
      throw Exception('Unexpected response body: $data');
    }

    return ScanAnalyzeResponse.fromJson((data).cast<String, dynamic>());
  }

  void logLong(String tag, String text) {
    const chunkSize = 800;
    for (var i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      debugPrint('$tag ${text.substring(i, end)}');
    }
  }

  Future<ScanHistoryDetailResponse> getScanHistoryDetails({
    required String scanId,
  }) async {
    final requestId = _uuid.v4();

    debugPrint(
        '➡️ [ScanHistoryDetails API] GET /v1/scan-history/$scanId/details');
    debugPrint('🧾 requestId: $requestId');

    try {
      final res = await _dio.get(
        '/v1/scan-history/$scanId/details',
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'X-Request-ID': requestId,
          },
        ),
      );

      debugPrint('✅ [ScanHistoryDetails API] success');
      debugPrint('🔍 status: ${res.statusCode}');
      debugPrint('🔍 headers: ${res.headers}');
      debugPrint('🔍 data runtimeType: ${res.data.runtimeType}');
      // debugPrint('🔍 raw body: ${res.data}');

      final resData = res.data;
      final pretty = const JsonEncoder.withIndent('  ').convert(resData);
      logLong('🔍 raw body:', pretty);

      if (res.statusCode != 200) {
        throw dio.DioException(
          requestOptions: res.requestOptions,
          response: res,
          type: dio.DioExceptionType.badResponse,
          message: 'GET details failed: ${res.statusCode}',
        );
      }

      final data = res.data;

      if (data is! Map) {
        throw Exception('Unexpected response body: $data');
      }

      debugPrint('🧩 [ScanHistoryDetails API] keys: ${(data).keys.toList()}');

      final parsed = ScanHistoryDetailResponse.fromJson(
        (data).cast<String, dynamic>(),
      );

      debugPrint('✅ [ScanHistoryDetails API] parsed ok: $parsed');

      return parsed;
    } on dio.DioException catch (e) {
      debugPrint('❌ [ScanHistoryDetails API] failed');
      debugPrint('🧾 requestId: $requestId');
      debugPrint('🔍 status: ${e.response?.statusCode}');
      debugPrint('🔍 data runtimeType: ${e.response?.data.runtimeType}');
      debugPrint('🔍 data: ${e.response?.data}');
      debugPrint('🔍 headers: ${e.response?.headers}');
      debugPrint('🔍 type: ${e.type}');
      rethrow;
    }
  }
}
