import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:healthy_scanner/core/app_secure_storage.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';

class ApiClient {
  ApiClient._();

  static const String baseUrl = "https://healthy-scanner.com";
  static const String refreshPath = "/v1/auth/refresh";

  static final dio.Dio dioClient = dio.Dio(
    dio.BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {"Content-Type": "application/json"},
    ),
  );

  static bool _isRefreshing = false;
  static final List<void Function(String?)> _refreshWaiters = [];

  static void setupInterceptors() {
    dioClient.interceptors.clear();

    dioClient.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await appSecureStorage.read(key: "jwt");
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          final status = e.response?.statusCode;
          final path = e.requestOptions.path;

          if (path == refreshPath) {
            return handler.next(e);
          }

          if (status == 401) {
            final auth = Get.find<AuthController>();

            if (_isRefreshing) {
              final completer = Completer<dio.Response?>();
              _refreshWaiters.add((newAccessToken) async {
                if (newAccessToken == null) {
                  completer.complete(null);
                  return;
                }
                try {
                  final retried = await _retryWithNewToken(
                    e.requestOptions,
                    newAccessToken,
                  );
                  completer.complete(retried);
                } catch (_) {
                  completer.complete(null);
                }
              });

              final retried = await completer.future;
              if (retried != null) {
                return handler.resolve(retried);
              }

              await auth.logout();
              return handler.next(e);
            }

            _isRefreshing = true;
            String? newAccessToken;
            try {
              newAccessToken = await auth.refreshAppToken();
            } finally {
              _isRefreshing = false;
            }

            for (final w in _refreshWaiters) {
              w(newAccessToken);
            }
            _refreshWaiters.clear();

            if (newAccessToken == null || newAccessToken.isEmpty) {
              await auth.logout();
              return handler.next(e);
            }

            try {
              final retried =
                  await _retryWithNewToken(e.requestOptions, newAccessToken);
              return handler.resolve(retried);
            } catch (_) {
              await auth.logout();
              return handler.next(e);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  static Future<dio.Response<dynamic>> _retryWithNewToken(
    dio.RequestOptions requestOptions,
    String newAccessToken,
  ) async {
    final headers = Map<String, dynamic>.from(requestOptions.headers)
      ..["Authorization"] = "Bearer $newAccessToken";

    final options = dio.Options(
      method: requestOptions.method,
      headers: headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      validateStatus: requestOptions.validateStatus,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
    );

    return dioClient.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
