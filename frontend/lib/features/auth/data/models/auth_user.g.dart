// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      isNewUser: json['isNewUser'] as bool? ?? false,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'nickname': instance.nickname,
      'isNewUser': instance.isNewUser,
      'onboardingComplete': instance.onboardingComplete,
    };
