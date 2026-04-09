import 'package:freezed_annotation/freezed_annotation.dart';

part 'alternative_itinerary.freezed.dart';
part 'alternative_itinerary.g.dart';

@freezed
class AlternativeItinerary with _$AlternativeItinerary {
  const factory AlternativeItinerary({
    required int id,
    required String title,
    required String reason,
    String? thumbnail,
    @Default([]) List<String> places,
    required int estimatedTime,
    required double accessibilityScore,
  }) = _AlternativeItinerary;

  factory AlternativeItinerary.fromJson(Map<String, dynamic> json) =>
      _$AlternativeItineraryFromJson(json);
}
