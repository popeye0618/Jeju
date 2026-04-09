import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'package:jeju_together/features/auth/data/models/signup_response.dart';
import 'package:jeju_together/features/auth/data/models/social_login_response.dart';
import 'package:jeju_together/features/auth/data/models/token_response.dart';
import 'auth_api.dart';

class AuthRepository {
  AuthRepository(this._api);

  final AuthApi _api;

  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final raw = await _api.login({'email': email, 'password': password});
      final data = raw['data'] as Map<String, dynamic>;
      return TokenResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<SignupResponse> signup({
    required String email,
    required String password,
  }) async {
    try {
      final raw = await _api.signup({'email': email, 'password': password});
      final data = raw['data'] as Map<String, dynamic>;
      return SignupResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<bool> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final raw = await _api.verifyEmail({'email': email, 'code': code});
      // 서버는 성공 시 data: null 반환 — 예외 없이 응답이 왔으면 성공
      return raw['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resendEmail({required String email}) async {
    try {
      await _api.resendEmail({'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _api.forgotPassword({'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _api.resetPassword({'token': token, 'newPassword': newPassword});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> refreshAccessToken({
    required String refreshToken,
  }) async {
    try {
      final raw =
          await _api.refreshToken({'refreshToken': refreshToken});
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<SocialLoginResponse> kakaoCallback({required String code}) async {
    try {
      final raw = await _api.kakaoCallback(code);
      final data = raw['data'] as Map<String, dynamic>;
      return SocialLoginResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<SocialLoginResponse> googleCallback({required String code}) async {
    try {
      final raw = await _api.googleCallback(code);
      final data = raw['data'] as Map<String, dynamic>;
      return SocialLoginResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
