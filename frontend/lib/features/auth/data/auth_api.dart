import 'package:dio/dio.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>('/auth/login', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>('/auth/signup', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> verifyEmail(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/auth/email/verify', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> resendEmail(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/auth/email/resend', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/auth/password/forgot', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/auth/password/reset', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/auth/token/refresh', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _dio.delete<Map<String, dynamic>>('/auth/logout');
    return response.data!;
  }

  Future<Map<String, dynamic>> kakaoLogin(String accessToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/kakao',
      data: {'accessToken': accessToken},
    );
    return response.data!;
  }

}
