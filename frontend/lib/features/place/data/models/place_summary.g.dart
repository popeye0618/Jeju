// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceSummaryImpl _$$PlaceSummaryImplFromJson(Map<String, dynamic> json) =>
    _$PlaceSummaryImpl(
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
    );

Map<String, dynamic> _$$PlaceSummaryImplToJson(_$PlaceSummaryImpl instance) =>
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
    };
