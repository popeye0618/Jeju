// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItinerarySummary _$ItinerarySummaryFromJson(Map<String, dynamic> json) {
  return _ItinerarySummary.fromJson(json);
}

/// @nodoc
mixin _$ItinerarySummary {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  List<String> get places => throw _privateConstructorUsedError;
  int get estimatedTime => throw _privateConstructorUsedError;
  double get accessibilityScore => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItinerarySummaryCopyWith<ItinerarySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItinerarySummaryCopyWith<$Res> {
  factory $ItinerarySummaryCopyWith(
          ItinerarySummary value, $Res Function(ItinerarySummary) then) =
      _$ItinerarySummaryCopyWithImpl<$Res, ItinerarySummary>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? thumbnail,
      List<String> places,
      int estimatedTime,
      double accessibilityScore,
      String type});
}

/// @nodoc
class _$ItinerarySummaryCopyWithImpl<$Res, $Val extends ItinerarySummary>
    implements $ItinerarySummaryCopyWith<$Res> {
  _$ItinerarySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? thumbnail = freezed,
    Object? places = null,
    Object? estimatedTime = null,
    Object? accessibilityScore = null,
    Object? type = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItinerarySummaryImplCopyWith<$Res>
    implements $ItinerarySummaryCopyWith<$Res> {
  factory _$$ItinerarySummaryImplCopyWith(_$ItinerarySummaryImpl value,
          $Res Function(_$ItinerarySummaryImpl) then) =
      __$$ItinerarySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? thumbnail,
      List<String> places,
      int estimatedTime,
      double accessibilityScore,
      String type});
}

/// @nodoc
class __$$ItinerarySummaryImplCopyWithImpl<$Res>
    extends _$ItinerarySummaryCopyWithImpl<$Res, _$ItinerarySummaryImpl>
    implements _$$ItinerarySummaryImplCopyWith<$Res> {
  __$$ItinerarySummaryImplCopyWithImpl(_$ItinerarySummaryImpl _value,
      $Res Function(_$ItinerarySummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? thumbnail = freezed,
    Object? places = null,
    Object? estimatedTime = null,
    Object? accessibilityScore = null,
    Object? type = null,
  }) {
    return _then(_$ItinerarySummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItinerarySummaryImpl implements _ItinerarySummary {
  const _$ItinerarySummaryImpl(
      {required this.id,
      required this.title,
      this.thumbnail,
      final List<String> places = const [],
      required this.estimatedTime,
      required this.accessibilityScore,
      required this.type})
      : _places = places;

  factory _$ItinerarySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItinerarySummaryImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
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
  final String type;

  @override
  String toString() {
    return 'ItinerarySummary(id: $id, title: $title, thumbnail: $thumbnail, places: $places, estimatedTime: $estimatedTime, accessibilityScore: $accessibilityScore, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItinerarySummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.accessibilityScore, accessibilityScore) ||
                other.accessibilityScore == accessibilityScore) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      thumbnail,
      const DeepCollectionEquality().hash(_places),
      estimatedTime,
      accessibilityScore,
      type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItinerarySummaryImplCopyWith<_$ItinerarySummaryImpl> get copyWith =>
      __$$ItinerarySummaryImplCopyWithImpl<_$ItinerarySummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItinerarySummaryImplToJson(
      this,
    );
  }
}

abstract class _ItinerarySummary implements ItinerarySummary {
  const factory _ItinerarySummary(
      {required final int id,
      required final String title,
      final String? thumbnail,
      final List<String> places,
      required final int estimatedTime,
      required final double accessibilityScore,
      required final String type}) = _$ItinerarySummaryImpl;

  factory _ItinerarySummary.fromJson(Map<String, dynamic> json) =
      _$ItinerarySummaryImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get thumbnail;
  @override
  List<String> get places;
  @override
  int get estimatedTime;
  @override
  double get accessibilityScore;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$ItinerarySummaryImplCopyWith<_$ItinerarySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
