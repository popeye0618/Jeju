import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int userId,
    required String email,
    required String nickname,
    required String provider,
    String? companion,
    List<String>? preference,
    List<String>? mobility,
    required int savedItineraryCount,
    required int likedPlaceCount,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
