// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternative_itinerary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlternativeItineraryImpl _$$AlternativeItineraryImplFromJson(
        Map<String, dynamic> json) =>
    _$AlternativeItineraryImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      reason: json['reason'] as String,
      thumbnail: json['thumbnail'] as String?,
      places: (json['places'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      estimatedTime: (json['estimatedTime'] as num).toInt(),
      accessibilityScore: (json['accessibilityScore'] as num).toDouble(),
    );

Map<String, dynamic> _$$AlternativeItineraryImplToJson(
        _$AlternativeItineraryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'reason': instance.reason,
      'thumbnail': instance.thumbnail,
      'places': instance.places,
      'estimatedTime': instance.estimatedTime,
      'accessibilityScore': instance.accessibilityScore,
    };
