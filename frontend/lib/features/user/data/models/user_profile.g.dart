// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      provider: json['provider'] as String,
      companion: json['companion'] as String?,
      preference: (json['preference'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mobility: (json['mobility'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      savedItineraryCount: (json['savedItineraryCount'] as num).toInt(),
      likedPlaceCount: (json['likedPlaceCount'] as num).toInt(),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'nickname': instance.nickname,
      'provider': instance.provider,
      'companion': instance.companion,
      'preference': instance.preference,
      'mobility': instance.mobility,
      'savedItineraryCount': instance.savedItineraryCount,
      'likedPlaceCount': instance.likedPlaceCount,
    };
