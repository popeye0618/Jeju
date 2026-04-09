// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialLoginResponseImpl _$$SocialLoginResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialLoginResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
      isNewUser: json['isNewUser'] as bool,
    );

Map<String, dynamic> _$$SocialLoginResponseImplToJson(
        _$SocialLoginResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
      'isNewUser': instance.isNewUser,
    };
