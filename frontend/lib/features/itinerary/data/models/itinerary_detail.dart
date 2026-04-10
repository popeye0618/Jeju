// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'place_in_itinerary.dart';

part 'itinerary_detail.freezed.dart';
part 'itinerary_detail.g.dart';

@freezed
class ItineraryDetail with _$ItineraryDetail {
  const factory ItineraryDetail({
    required int id,
    required String title,
    required int days,
    required int estimatedTime,
    required int savedCount,
    @JsonKey(name: 'saved') @Default(false) bool isSaved,
    @Default([]) List<PlaceInItinerary> places,
  }) = _ItineraryDetail;

  factory ItineraryDetail.fromJson(Map<String, dynamic> json) =>
      _$ItineraryDetailFromJson(json);
}
