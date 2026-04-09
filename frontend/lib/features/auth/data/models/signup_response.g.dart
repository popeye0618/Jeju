// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupResponseImpl _$$SignupResponseImplFromJson(Map<String, dynamic> json) =>
    _$SignupResponseImpl(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool,
    );

Map<String, dynamic> _$$SignupResponseImplToJson(
        _$SignupResponseImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
    };
