import 'package:dio/dio.dart';
import 'api_response.dart';

class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.errors,
  });

  final String code;
  final String message;
  final int? statusCode;
  final List<FieldError>? errors;

  factory ApiException.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final code = data['code'] as String? ?? _codeFromStatus(statusCode);
      final message = data['message'] as String? ?? e.message ?? '알 수 없는 오류가 발생했습니다.';
      final rawErrors = data['errors'] as List<dynamic>?;
      final errors = rawErrors
          ?.map((e) => FieldError.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiException(
        code: code,
        message: message,
        statusCode: statusCode,
        errors: errors,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          code: 'TIMEOUT',
          message: '네트워크 연결 시간이 초과되었습니다.',
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          code: 'CONNECTION_ERROR',
          message: '서버에 연결할 수 없습니다. 인터넷 연결을 확인해주세요.',
          statusCode: statusCode,
        );
      default:
        return ApiException(
          code: _codeFromStatus(statusCode),
          message: e.message ?? '알 수 없는 오류가 발생했습니다.',
          statusCode: statusCode,
        );
    }
  }

  static String _codeFromStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'BAD_REQUEST';
      case 401:
        return 'UNAUTHORIZED';
      case 403:
        return 'FORBIDDEN';
      case 404:
        return 'NOT_FOUND';
      case 409:
        return 'CONFLICT';
      case 500:
        return 'INTERNAL_SERVER_ERROR';
      default:
        return 'UNKNOWN_ERROR';
    }
  }

  @override
  String toString() => 'ApiException(code: $code, message: $message, statusCode: $statusCode)';
}
