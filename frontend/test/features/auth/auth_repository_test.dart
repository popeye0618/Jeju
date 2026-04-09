import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/features/auth/data/auth_api.dart';
import 'package:jeju_together/features/auth/data/auth_repository.dart';
import 'package:jeju_together/features/auth/data/models/signup_response.dart';
import 'package:jeju_together/features/auth/data/models/token_response.dart';

/// 테스트용 MockAuthApi
class MockAuthApi implements AuthApi {
  MockAuthApi({
    this.loginResult,
    this.signupResult,
    this.shouldThrow = false,
  });

  final Map<String, dynamic>? loginResult;
  final Map<String, dynamic>? signupResult;
  final bool shouldThrow;

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    if (shouldThrow) throw Exception('network error');
    return loginResult ??
        {
          'success': true,
          'code': 'SUCCESS',
          'message': '로그인 성공',
          'data': {
            'accessToken': 'test_access',
            'refreshToken': 'test_refresh',
            'tokenType': 'Bearer',
            'expiresIn': 3600,
          },
        };
  }

  @override
  Future<Map<String, dynamic>> signup(Map<String, dynamic> body) async {
    if (shouldThrow) throw Exception('network error');
    return signupResult ??
        {
          'success': true,
          'code': 'SUCCESS',
          'message': '회원가입 성공',
          'data': {
            'userId': 1,
            'email': 'test@test.com',
            'emailVerified': false,
          },
        };
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(Map<String, dynamic> body) async =>
      {
        'success': true,
        'code': 'SUCCESS',
        'message': '',
        'data': {'emailVerified': true},
      };

  @override
  Future<Map<String, dynamic>> resendEmail(Map<String, dynamic> body) async =>
      {'success': true, 'code': 'SUCCESS', 'message': '', 'data': null};

  @override
  Future<Map<String, dynamic>> forgotPassword(
          Map<String, dynamic> body) async =>
      {'success': true, 'code': 'SUCCESS', 'message': '', 'data': null};

  @override
  Future<Map<String, dynamic>> resetPassword(
          Map<String, dynamic> body) async =>
      {'success': true, 'code': 'SUCCESS', 'message': '', 'data': null};

  @override
  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> body) async =>
      {
        'success': true,
        'code': 'SUCCESS',
        'message': '',
        'data': {
          'accessToken': 'new_access',
          'tokenType': 'Bearer',
          'expiresIn': 3600,
        },
      };

  @override
  Future<Map<String, dynamic>> logout() async =>
      {'success': true, 'code': 'SUCCESS', 'message': '', 'data': null};

  @override
  Future<Map<String, dynamic>> kakaoCallback(String code) async =>
      {'success': true, 'code': 'SUCCESS', 'message': '', 'data': null};

  @override
  Future<Map<String, dynamic>> googleCallback(String code) async =>
      {'success': true, 'code': 'SUCCESS', 'message': '', 'data': null};
}

void main() {
  group('AuthRepository', () {
    late AuthRepository sut;

    setUp(() {
      sut = AuthRepository(MockAuthApi());
    });

    test('login이 TokenResponse를 반환한다', () async {
      final result = await sut.login(
        email: 'test@test.com',
        password: 'password123',
      );

      expect(result, isA<TokenResponse>());
    });

    test('signup이 SignupResponse를 반환한다', () async {
      final result = await sut.signup(
        email: 'test@test.com',
        password: 'password123',
      );

      expect(result, isA<SignupResponse>());
    });

    test('verifyEmail이 bool을 반환한다', () async {
      final result = await sut.verifyEmail(
        email: 'test@test.com',
        code: '123456',
      );

      expect(result, isTrue);
    });

    test('logout이 예외 없이 완료된다', () async {
      await expectLater(sut.logout(), completes);
    });
  });

  group('AuthRepository 예외 처리', () {
    test('예외가 발생하면 전파된다', () async {
      final repo = AuthRepository(MockAuthApi(shouldThrow: true));

      await expectLater(
        () => repo.login(email: 'test@test.com', password: 'pw'),
        throwsException,
      );
    });
  });
}
