// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItineraryDetailImpl _$$ItineraryDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ItineraryDetailImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      days: (json['days'] as num).toInt(),
      estimatedTime: (json['estimatedTime'] as num).toInt(),
      savedCount: (json['savedCount'] as num).toInt(),
      isSaved: json['isSaved'] as bool,
      places: (json['places'] as List<dynamic>?)
              ?.map((e) => PlaceInItinerary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ItineraryDetailImplToJson(
        _$ItineraryDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'days': instance.days,
      'estimatedTime': instance.estimatedTime,
      'savedCount': instance.savedCount,
      'isSaved': instance.isSaved,
      'places': instance.places,
    };
