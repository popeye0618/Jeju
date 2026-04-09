// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewItemImpl _$$ReviewItemImplFromJson(Map<String, dynamic> json) =>
    _$ReviewItemImpl(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
      rating: (json['rating'] as num).toDouble(),
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String,
      isOwner: json['isOwner'] as bool,
    );

Map<String, dynamic> _$$ReviewItemImplToJson(_$ReviewItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'rating': instance.rating,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'createdAt': instance.createdAt,
      'isOwner': instance.isOwner,
    };
