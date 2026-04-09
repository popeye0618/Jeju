import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class ApiClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 요청 인터셉터: 토큰 자동 주입
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AppConfig.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // 401 → Refresh Token으로 재발급 시도
          if (error.response?.statusCode == 401) {
            final refreshToken = await AppConfig.getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshDio = Dio(
                  BaseOptions(baseUrl: AppConfig.baseUrl),
                );
                final response = await refreshDio.post(
                  '/auth/token/refresh',
                  data: {'refreshToken': refreshToken},
                );
                final newAccessToken = response.data['accessToken'];
                final newRefreshToken = response.data['refreshToken'];
                await AppConfig.saveTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                );
                // 원래 요청 재시도
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                final retryResponse = await dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              } catch (_) {
                await AppConfig.clearTokens();
              }
            }
          }
          handler.next(error);
        },
      ),
    );

    // 개발 환경에서만 로그 출력
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    return dio;
  }
}
