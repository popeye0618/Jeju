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
      places: (json['places'] as num?)?.toInt() ?? 0,
      estimatedTime: (json['estimatedTime'] as num).toInt(),
      accessibilityScore: (json['accessibilityScore'] as num?)?.toInt() ?? 0,
      type: json['type'] as String,
      isSaved: json['saved'] as bool? ?? false,
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
      'saved': instance.isSaved,
    };
