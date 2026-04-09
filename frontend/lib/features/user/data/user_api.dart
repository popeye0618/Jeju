import 'package:dio/dio.dart';

class UserApi {
  UserApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> checkNickname(String nickname) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/nickname/check',
      queryParameters: {'nickname': nickname},
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> postOnboarding(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/users/onboarding', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    final response = await _dio.get<Map<String, dynamic>>('/users/me');
    return response.data!;
  }

  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> body) async {
    final response =
        await _dio.patch<Map<String, dynamic>>('/users/me', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> deleteMyAccount() async {
    final response = await _dio.delete<Map<String, dynamic>>('/users/me');
    return response.data!;
  }
}
