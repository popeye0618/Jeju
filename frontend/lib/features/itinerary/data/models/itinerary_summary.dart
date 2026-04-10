// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'itinerary_summary.freezed.dart';
part 'itinerary_summary.g.dart';

@freezed
class ItinerarySummary with _$ItinerarySummary {
  const factory ItinerarySummary({
    required int id,
    required String title,
    String? thumbnail,
    /// 백엔드가 int(장소 개수)로 내려줌
    @Default(0) int places,
    required int estimatedTime,
    /// 백엔드가 Integer(nullable)로 내려줌 → null 시 0
    @Default(0) int accessibilityScore,
    required String type,
    /// 백엔드 Jackson: isSaved() → JSON key "saved"
    @JsonKey(name: 'saved') @Default(false) bool isSaved,
  }) = _ItinerarySummary;

  factory ItinerarySummary.fromJson(Map<String, dynamic> json) =>
      _$ItinerarySummaryFromJson(json);
}
