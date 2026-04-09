import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_summary.freezed.dart';
part 'place_summary.g.dart';

@freezed
class PlaceSummary with _$PlaceSummary {
  const factory PlaceSummary({
    required int id,
    required String name,
    required String category,
    required String address,
    String? thumbnail,
    required bool hasRamp,
    required bool hasElevator,
    required bool hasAccessibleToilet,
    required bool hasRestZone,
    required bool hasAccessibleParking,
    required bool isLiked,
  }) = _PlaceSummary;

  factory PlaceSummary.fromJson(Map<String, dynamic> json) =>
      _$PlaceSummaryFromJson(json);
}
