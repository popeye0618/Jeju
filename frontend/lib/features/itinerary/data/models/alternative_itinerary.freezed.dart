// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alternative_itinerary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlternativeItinerary _$AlternativeItineraryFromJson(Map<String, dynamic> json) {
  return _AlternativeItinerary.fromJson(json);
}

/// @nodoc
mixin _$AlternativeItinerary {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  List<String> get places => throw _privateConstructorUsedError;
  int get estimatedTime => throw _privateConstructorUsedError;
  double get accessibilityScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlternativeItineraryCopyWith<AlternativeItinerary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlternativeItineraryCopyWith<$Res> {
  factory $AlternativeItineraryCopyWith(AlternativeItinerary value,
          $Res Function(AlternativeItinerary) then) =
      _$AlternativeItineraryCopyWithImpl<$Res, AlternativeItinerary>;
  @useResult
  $Res call(
      {int id,
      String title,
      String reason,
      String? thumbnail,
      List<String> places,
      int estimatedTime,
      double accessibilityScore});
}

/// @nodoc
class _$AlternativeItineraryCopyWithImpl<$Res,
        $Val extends AlternativeItinerary>
    implements $AlternativeItineraryCopyWith<$Res> {
  _$AlternativeItineraryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reason = null,
    Object? thumbnail = freezed,
    Object? places = null,
    Object? estimatedTime = null,
    Object? accessibilityScore = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int,
      accessibilityScore: null == accessibilityScore
          ? _value.accessibilityScore
          : accessibilityScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlternativeItineraryImplCopyWith<$Res>
    implements $AlternativeItineraryCopyWith<$Res> {
  factory _$$AlternativeItineraryImplCopyWith(_$AlternativeItineraryImpl value,
          $Res Function(_$AlternativeItineraryImpl) then) =
      __$$AlternativeItineraryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String reason,
      String? thumbnail,
      List<String> places,
      int estimatedTime,
      double accessibilityScore});
}

/// @nodoc
class __$$AlternativeItineraryImplCopyWithImpl<$Res>
    extends _$AlternativeItineraryCopyWithImpl<$Res, _$AlternativeItineraryImpl>
    implements _$$AlternativeItineraryImplCopyWith<$Res> {
  __$$AlternativeItineraryImplCopyWithImpl(_$AlternativeItineraryImpl _value,
      $Res Function(_$AlternativeItineraryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reason = null,
    Object? thumbnail = freezed,
    Object? places = null,
    Object? estimatedTime = null,
    Object? accessibilityScore = null,
  }) {
    return _then(_$AlternativeItineraryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int,
      accessibilityScore: null == accessibilityScore
          ? _value.accessibilityScore
          : accessibilityScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlternativeItineraryImpl implements _AlternativeItinerary {
  const _$AlternativeItineraryImpl(
      {required this.id,
      required this.title,
      required this.reason,
      this.thumbnail,
      final List<String> places = const [],
      required this.estimatedTime,
      required this.accessibilityScore})
      : _places = places;

  factory _$AlternativeItineraryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlternativeItineraryImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String reason;
  @override
  final String? thumbnail;
  final List<String> _places;
  @override
  @JsonKey()
  List<String> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  @override
  final int estimatedTime;
  @override
  final double accessibilityScore;

  @override
  String toString() {
    return 'AlternativeItinerary(id: $id, title: $title, reason: $reason, thumbnail: $thumbnail, places: $places, estimatedTime: $estimatedTime, accessibilityScore: $accessibilityScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlternativeItineraryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.accessibilityScore, accessibilityScore) ||
                other.accessibilityScore == accessibilityScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      reason,
      thumbnail,
      const DeepCollectionEquality().hash(_places),
      estimatedTime,
      accessibilityScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlternativeItineraryImplCopyWith<_$AlternativeItineraryImpl>
      get copyWith =>
          __$$AlternativeItineraryImplCopyWithImpl<_$AlternativeItineraryImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlternativeItineraryImplToJson(
      this,
    );
  }
}

abstract class _AlternativeItinerary implements AlternativeItinerary {
  const factory _AlternativeItinerary(
      {required final int id,
      required final String title,
      required final String reason,
      final String? thumbnail,
      final List<String> places,
      required final int estimatedTime,
      required final double accessibilityScore}) = _$AlternativeItineraryImpl;

  factory _AlternativeItinerary.fromJson(Map<String, dynamic> json) =
      _$AlternativeItineraryImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get reason;
  @override
  String? get thumbnail;
  @override
  List<String> get places;
  @override
  int get estimatedTime;
  @override
  double get accessibilityScore;
  @override
  @JsonKey(ignore: true)
  _$$AlternativeItineraryImplCopyWith<_$AlternativeItineraryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
