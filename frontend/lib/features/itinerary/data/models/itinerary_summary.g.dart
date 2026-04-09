// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItinerarySummaryImpl _$$ItinerarySummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ItinerarySummaryImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String?,
      places: (json['places'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      estimatedTime: (json['estimatedTime'] as num).toInt(),
      accessibilityScore: (json['accessibilityScore'] as num).toDouble(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$ItinerarySummaryImplToJson(
        _$ItinerarySummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'places': instance.places,
      'estimatedTime': instance.estimatedTime,
      'accessibilityScore': instance.accessibilityScore,
      'type': instance.type,
    };
