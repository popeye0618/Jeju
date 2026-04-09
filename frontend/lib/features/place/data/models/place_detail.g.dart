// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceDetailImpl _$$PlaceDetailImplFromJson(Map<String, dynamic> json) =>
    _$PlaceDetailImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      address: json['address'] as String,
      thumbnail: json['thumbnail'] as String?,
      hasRamp: json['hasRamp'] as bool,
      hasElevator: json['hasElevator'] as bool,
      hasAccessibleToilet: json['hasAccessibleToilet'] as bool,
      hasRestZone: json['hasRestZone'] as bool,
      hasAccessibleParking: json['hasAccessibleParking'] as bool,
      isLiked: json['isLiked'] as bool,
      tel: json['tel'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      reviewCount: (json['reviewCount'] as num).toInt(),
      avgRating: (json['avgRating'] as num).toDouble(),
    );

Map<String, dynamic> _$$PlaceDetailImplToJson(_$PlaceDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'address': instance.address,
      'thumbnail': instance.thumbnail,
      'hasRamp': instance.hasRamp,
      'hasElevator': instance.hasElevator,
      'hasAccessibleToilet': instance.hasAccessibleToilet,
      'hasRestZone': instance.hasRestZone,
      'hasAccessibleParking': instance.hasAccessibleParking,
      'isLiked': instance.isLiked,
      'tel': instance.tel,
      'lat': instance.lat,
      'lng': instance.lng,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'images': instance.images,
      'reviewCount': instance.reviewCount,
      'avgRating': instance.avgRating,
    };
