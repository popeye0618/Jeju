// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecentPlaceImpl _$$RecentPlaceImplFromJson(Map<String, dynamic> json) =>
    _$RecentPlaceImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      thumbnail: json['thumbnail'] as String?,
      viewedAt: json['viewedAt'] as String,
    );

Map<String, dynamic> _$$RecentPlaceImplToJson(_$RecentPlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'thumbnail': instance.thumbnail,
      'viewedAt': instance.viewedAt,
    };
