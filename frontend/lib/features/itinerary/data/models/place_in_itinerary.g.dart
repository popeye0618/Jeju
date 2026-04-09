// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_in_itinerary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceInItineraryImpl _$$PlaceInItineraryImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaceInItineraryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
      hasRamp: json['hasRamp'] as bool,
      hasElevator: json['hasElevator'] as bool,
      hasAccessibleToilet: json['hasAccessibleToilet'] as bool,
      hasRestZone: json['hasRestZone'] as bool,
      hasAccessibleParking: json['hasAccessibleParking'] as bool,
    );

Map<String, dynamic> _$$PlaceInItineraryImplToJson(
        _$PlaceInItineraryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'day': instance.day,
      'lat': instance.lat,
      'lng': instance.lng,
      'estimatedMinutes': instance.estimatedMinutes,
      'hasRamp': instance.hasRamp,
      'hasElevator': instance.hasElevator,
      'hasAccessibleToilet': instance.hasAccessibleToilet,
      'hasRestZone': instance.hasRestZone,
      'hasAccessibleParking': instance.hasAccessibleParking,
    };
