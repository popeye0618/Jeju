import 'package:freezed_annotation/freezed_annotation.dart';

part 'itinerary_summary.freezed.dart';
part 'itinerary_summary.g.dart';

@freezed
class ItinerarySummary with _$ItinerarySummary {
  const factory ItinerarySummary({
    required int id,
    required String title,
    String? thumbnail,
    @Default([]) List<String> places,
    required int estimatedTime,
    required double accessibilityScore,
    required String type,
  }) = _ItinerarySummary;

  factory ItinerarySummary.fromJson(Map<String, dynamic> json) =>
      _$ItinerarySummaryFromJson(json);
}
