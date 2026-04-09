import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_detail.freezed.dart';
part 'place_detail.g.dart';

@freezed
class PlaceDetail with _$PlaceDetail {
  const factory PlaceDetail({
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
    String? tel,
    required double lat,
    required double lng,
    String? openTime,
    String? closeTime,
    @Default([]) List<String> images,
    required int reviewCount,
    required double avgRating,
  }) = _PlaceDetail;

  factory PlaceDetail.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailFromJson(json);
}
