import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_place.freezed.dart';
part 'recent_place.g.dart';

@freezed
class RecentPlace with _$RecentPlace {
  const factory RecentPlace({
    required int id,
    required String name,
    required String category,
    String? thumbnail,
    required String viewedAt,
  }) = _RecentPlace;

  factory RecentPlace.fromJson(Map<String, dynamic> json) =>
      _$RecentPlaceFromJson(json);
}
