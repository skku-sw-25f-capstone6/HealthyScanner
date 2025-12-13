import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class ScanAnalyzeResponse {
  final String scanId;
  final String productId;
  final String nutritionId;
  final String ingredientId;

  ScanAnalyzeResponse({
    required this.scanId,
    required this.productId,
    required this.nutritionId,
    required this.ingredientId,
  });

  factory ScanAnalyzeResponse.fromJson(Map<String, dynamic> json) {
    return ScanAnalyzeResponse(
      scanId: json['scan_id'] as String,
      productId: json['product_id'] as String,
      nutritionId: json['nutrition_id'] as String,
      ingredientId: json['ingredient_id'] as String,
    );
  }
}

class ScanApi {
  final Dio _dio;
  final Uuid _uuid = const Uuid();

  ScanApi({
    required String baseUrl,
    Dio? dio,
  }) : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 120),
              sendTimeout: const Duration(seconds: 60),
            ));

  Future<ScanAnalyzeResponse> analyzeBarcodeImage({
    required String jwt,
    required Uint8List imageBytes,
    String? barcode,
  }) async {
    final requestId = _uuid.v4();

    final formData = FormData.fromMap({
      if (barcode != null && barcode.trim().isNotEmpty)
        'barcode': barcode.trim(),
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: 'scan.jpg',
        contentType: DioMediaType.parse('image/jpeg'),
      ),
    });

    try {
      final res = await _dio.post(
        '/v1/scan-history/barcode_image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Accept': 'application/json',
            'X-Request-ID': requestId,
          },
        ),
      );

      return _parseScanAnalyzeResponse(res);
    } on DioException catch (e) {
      debugPrint('❌ [Barcode API]');
      debugPrint('🔍 status: ${e.response?.statusCode}');
      debugPrint('🔍 data: ${e.response?.data}');
      debugPrint('🔍 headers: ${e.response?.headers}');
      rethrow;
    }
  }

  Future<ScanAnalyzeResponse> analyzeNutritionLabel({
    required String jwt,
    required Uint8List imageBytes,
    required String nutritionLabel,
  }) async {
    final requestId = _uuid.v4();

    final formData = FormData.fromMap({
      'nutrition_label': nutritionLabel,
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: 'scan.jpg',
        contentType: DioMediaType.parse('image/jpeg'),
      ),
    });

    try {
      final res = await _dio.post(
        '/v1/scan-history/nutrition_label',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Accept': 'application/json',
            'X-Request-ID': requestId,
          },
        ),
      );

      return _parseScanAnalyzeResponse(res);
    } on DioException catch (e) {
      debugPrint('❌ [NutritionLabel API]');
      debugPrint('📝 status: ${e.response?.statusCode}');
      debugPrint('📝 data: ${e.response?.data}');
      debugPrint('📝 headers: ${e.response?.headers}');
      rethrow;
    }
  }

  Future<ScanAnalyzeResponse> analyzeImageOnly({
    required String jwt,
    required Uint8List imageBytes,
  }) async {
    final requestId = _uuid.v4();

    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: 'scan.jpg',
        contentType: DioMediaType.parse('image/jpeg'),
      ),
    });

    try {
      final res = await _dio.post(
        '/v1/scan-history/image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Accept': 'application/json',
            'X-Request-ID': requestId,
          },
        ),
      );

      return _parseScanAnalyzeResponse(res);
    } on DioException catch (e) {
      debugPrint('❌ [ImageOnly API]');
      debugPrint('🖼️ status: ${e.response?.statusCode}');
      debugPrint('🖼️ data: ${e.response?.data}');
      debugPrint('🖼️ headers: ${e.response?.headers}');
      rethrow;
    }
  }

  ScanAnalyzeResponse _parseScanAnalyzeResponse(Response res) {
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
        message: 'Analyze failed: ${res.statusCode}',
      );
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response body: $data');
    }

    return ScanAnalyzeResponse.fromJson(data);
  }
}
