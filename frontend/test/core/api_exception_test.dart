import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/core/network/api_exception.dart';

void main() {
  group('ApiException', () {
    test('생성자가 필드를 올바르게 저장한다', () {
      const exception = ApiException(
        code: 'AUTH_001',
        message: '인증에 실패했습니다.',
        statusCode: 401,
      );

      expect(exception.code, equals('AUTH_001'));
      expect(exception.message, equals('인증에 실패했습니다.'));
      expect(exception.statusCode, equals(401));
      expect(exception.errors, isNull);
    });

    test('toString이 코드와 메시지를 포함한다', () {
      const exception = ApiException(
        code: 'NOT_FOUND',
        message: '리소스를 찾을 수 없습니다.',
        statusCode: 404,
      );

      final str = exception.toString();
      expect(str, contains('NOT_FOUND'));
      expect(str, contains('404'));
    });

    test('_codeFromStatus가 알려진 상태 코드를 올바르게 변환한다', () {
      final cases = {
        400: 'BAD_REQUEST',
        401: 'UNAUTHORIZED',
        403: 'FORBIDDEN',
        404: 'NOT_FOUND',
        409: 'CONFLICT',
        500: 'INTERNAL_SERVER_ERROR',
      };

      for (final entry in cases.entries) {
        final exception = ApiException(
          code: entry.value,
          message: 'test',
          statusCode: entry.key,
        );
        expect(exception.code, equals(entry.value));
      }
    });

    test('implements Exception', () {
      const exception = ApiException(code: 'TEST', message: 'test');
      expect(exception, isA<Exception>());
    });
  });
}
