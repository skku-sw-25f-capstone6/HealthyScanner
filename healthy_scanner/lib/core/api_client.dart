import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:healthy_scanner/core/app_secure_storage.dart';

class ApiClient {
  ApiClient._();

  static final dio = Dio(
    BaseOptions(
      baseUrl: "https://healthy-scanner.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final jwt = await appSecureStorage.read(key: "jwt");
          if (jwt != null && jwt.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $jwt";
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          debugPrint(
              "❌ API error: ${e.response?.statusCode} ${e.requestOptions.path}");
          return handler.next(e);
        },
      ),
    );
}
