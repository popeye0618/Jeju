// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  int get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String? get companion => throw _privateConstructorUsedError;
  List<String>? get preference => throw _privateConstructorUsedError;
  List<String>? get mobility => throw _privateConstructorUsedError;
  int get savedItineraryCount => throw _privateConstructorUsedError;
  int get likedPlaceCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {int userId,
      String email,
      String nickname,
      String provider,
      String? companion,
      List<String>? preference,
      List<String>? mobility,
      int savedItineraryCount,
      int likedPlaceCount});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? nickname = null,
    Object? provider = null,
    Object? companion = freezed,
    Object? preference = freezed,
    Object? mobility = freezed,
    Object? savedItineraryCount = null,
    Object? likedPlaceCount = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      companion: freezed == companion
          ? _value.companion
          : companion // ignore: cast_nullable_to_non_nullable
              as String?,
      preference: freezed == preference
          ? _value.preference
          : preference // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mobility: freezed == mobility
          ? _value.mobility
          : mobility // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      savedItineraryCount: null == savedItineraryCount
          ? _value.savedItineraryCount
          : savedItineraryCount // ignore: cast_nullable_to_non_nullable
              as int,
      likedPlaceCount: null == likedPlaceCount
          ? _value.likedPlaceCount
          : likedPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int userId,
      String email,
      String nickname,
      String provider,
      String? companion,
      List<String>? preference,
      List<String>? mobility,
      int savedItineraryCount,
      int likedPlaceCount});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? nickname = null,
    Object? provider = null,
    Object? companion = freezed,
    Object? preference = freezed,
    Object? mobility = freezed,
    Object? savedItineraryCount = null,
    Object? likedPlaceCount = null,
  }) {
    return _then(_$UserProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      companion: freezed == companion
          ? _value.companion
          : companion // ignore: cast_nullable_to_non_nullable
              as String?,
      preference: freezed == preference
          ? _value._preference
          : preference // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mobility: freezed == mobility
          ? _value._mobility
          : mobility // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      savedItineraryCount: null == savedItineraryCount
          ? _value.savedItineraryCount
          : savedItineraryCount // ignore: cast_nullable_to_non_nullable
              as int,
      likedPlaceCount: null == likedPlaceCount
          ? _value.likedPlaceCount
          : likedPlaceCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.userId,
      required this.email,
      required this.nickname,
      required this.provider,
      this.companion,
      final List<String>? preference,
      final List<String>? mobility,
      required this.savedItineraryCount,
      required this.likedPlaceCount})
      : _preference = preference,
        _mobility = mobility;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final int userId;
  @override
  final String email;
  @override
  final String nickname;
  @override
  final String provider;
  @override
  final String? companion;
  final List<String>? _preference;
  @override
  List<String>? get preference {
    final value = _preference;
    if (value == null) return null;
    if (_preference is EqualUnmodifiableListView) return _preference;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _mobility;
  @override
  List<String>? get mobility {
    final value = _mobility;
    if (value == null) return null;
    if (_mobility is EqualUnmodifiableListView) return _mobility;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int savedItineraryCount;
  @override
  final int likedPlaceCount;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, email: $email, nickname: $nickname, provider: $provider, companion: $companion, preference: $preference, mobility: $mobility, savedItineraryCount: $savedItineraryCount, likedPlaceCount: $likedPlaceCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.companion, companion) ||
                other.companion == companion) &&
            const DeepCollectionEquality()
                .equals(other._preference, _preference) &&
            const DeepCollectionEquality().equals(other._mobility, _mobility) &&
            (identical(other.savedItineraryCount, savedItineraryCount) ||
                other.savedItineraryCount == savedItineraryCount) &&
            (identical(other.likedPlaceCount, likedPlaceCount) ||
                other.likedPlaceCount == likedPlaceCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      email,
      nickname,
      provider,
      companion,
      const DeepCollectionEquality().hash(_preference),
      const DeepCollectionEquality().hash(_mobility),
      savedItineraryCount,
      likedPlaceCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final int userId,
      required final String email,
      required final String nickname,
      required final String provider,
      final String? companion,
      final List<String>? preference,
      final List<String>? mobility,
      required final int savedItineraryCount,
      required final int likedPlaceCount}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  int get userId;
  @override
  String get email;
  @override
  String get nickname;
  @override
  String get provider;
  @override
  String? get companion;
  @override
  List<String>? get preference;
  @override
  List<String>? get mobility;
  @override
  int get savedItineraryCount;
  @override
  int get likedPlaceCount;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
