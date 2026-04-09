import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_item.freezed.dart';
part 'review_item.g.dart';

@freezed
class ReviewItem with _$ReviewItem {
  const factory ReviewItem({
    required int id,
    required String nickname,
    required double rating,
    required String content,
    @Default([]) List<String> imageUrls,
    required String createdAt,
    required bool isOwner,
  }) = _ReviewItem;

  factory ReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ReviewItemFromJson(json);
}
