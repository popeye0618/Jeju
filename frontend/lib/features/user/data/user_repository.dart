import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'package:jeju_together/features/user/data/models/user_profile.dart';
import 'user_api.dart';

class UserRepository {
  UserRepository(this._api);

  final UserApi _api;

  Future<bool> checkNickname(String nickname) async {
    try {
      final raw = await _api.checkNickname(nickname);
      final data = raw['data'] as Map<String, dynamic>?;
      return data?['available'] as bool? ?? false;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> postOnboarding({
    required String nickname,
    String? companion,
    List<String>? preference,
    List<String>? mobility,
  }) async {
    try {
      final body = <String, dynamic>{
        'nickname': nickname,
        if (companion != null) 'companion': companion,
        if (preference != null) 'preference': preference,
        if (mobility != null) 'mobility': mobility,
      };
      final raw = await _api.postOnboarding(body);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<UserProfile> getMyProfile() async {
    try {
      final raw = await _api.getMyProfile();
      final data = raw['data'] as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> updateMyProfile({
    String? nickname,
    String? companion,
  }) async {
    try {
      final body = <String, dynamic>{
        if (nickname != null) 'nickname': nickname,
        if (companion != null) 'companion': companion,
      };
      final raw = await _api.updateMyProfile(body);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> deleteMyAccount() async {
    try {
      await _api.deleteMyAccount();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
