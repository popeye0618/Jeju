import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_login_response.freezed.dart';
part 'social_login_response.g.dart';

@freezed
class SocialLoginResponse with _$SocialLoginResponse {
  const factory SocialLoginResponse({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
    required bool isNewUser,
  }) = _SocialLoginResponse;

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginResponseFromJson(json);
}
