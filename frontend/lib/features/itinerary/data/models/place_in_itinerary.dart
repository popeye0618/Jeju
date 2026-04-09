import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_in_itinerary.freezed.dart';
part 'place_in_itinerary.g.dart';

@freezed
class PlaceInItinerary with _$PlaceInItinerary {
  const factory PlaceInItinerary({
    required int id,
    required String name,
    required int order,
    required int day,
    required double lat,
    required double lng,
    required int estimatedMinutes,
    required bool hasRamp,
    required bool hasElevator,
    required bool hasAccessibleToilet,
    required bool hasRestZone,
    required bool hasAccessibleParking,
  }) = _PlaceInItinerary;

  factory PlaceInItinerary.fromJson(Map<String, dynamic> json) =>
      _$PlaceInItineraryFromJson(json);
}
