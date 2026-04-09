// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItineraryDetail _$ItineraryDetailFromJson(Map<String, dynamic> json) {
  return _ItineraryDetail.fromJson(json);
}

/// @nodoc
mixin _$ItineraryDetail {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get days => throw _privateConstructorUsedError;
  int get estimatedTime => throw _privateConstructorUsedError;
  int get savedCount => throw _privateConstructorUsedError;
  bool get isSaved => throw _privateConstructorUsedError;
  List<PlaceInItinerary> get places => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItineraryDetailCopyWith<ItineraryDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItineraryDetailCopyWith<$Res> {
  factory $ItineraryDetailCopyWith(
          ItineraryDetail value, $Res Function(ItineraryDetail) then) =
      _$ItineraryDetailCopyWithImpl<$Res, ItineraryDetail>;
  @useResult
  $Res call(
      {int id,
      String title,
      int days,
      int estimatedTime,
      int savedCount,
      bool isSaved,
      List<PlaceInItinerary> places});
}

/// @nodoc
class _$ItineraryDetailCopyWithImpl<$Res, $Val extends ItineraryDetail>
    implements $ItineraryDetailCopyWith<$Res> {
  _$ItineraryDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? days = null,
    Object? estimatedTime = null,
    Object? savedCount = null,
    Object? isSaved = null,
    Object? places = null,
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
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int,
      savedCount: null == savedCount
          ? _value.savedCount
          : savedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSaved: null == isSaved
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceInItinerary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItineraryDetailImplCopyWith<$Res>
    implements $ItineraryDetailCopyWith<$Res> {
  factory _$$ItineraryDetailImplCopyWith(_$ItineraryDetailImpl value,
          $Res Function(_$ItineraryDetailImpl) then) =
      __$$ItineraryDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      int days,
      int estimatedTime,
      int savedCount,
      bool isSaved,
      List<PlaceInItinerary> places});
}

/// @nodoc
class __$$ItineraryDetailImplCopyWithImpl<$Res>
    extends _$ItineraryDetailCopyWithImpl<$Res, _$ItineraryDetailImpl>
    implements _$$ItineraryDetailImplCopyWith<$Res> {
  __$$ItineraryDetailImplCopyWithImpl(
      _$ItineraryDetailImpl _value, $Res Function(_$ItineraryDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? days = null,
    Object? estimatedTime = null,
    Object? savedCount = null,
    Object? isSaved = null,
    Object? places = null,
  }) {
    return _then(_$ItineraryDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int,
      savedCount: null == savedCount
          ? _value.savedCount
          : savedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSaved: null == isSaved
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceInItinerary>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItineraryDetailImpl implements _ItineraryDetail {
  const _$ItineraryDetailImpl(
      {required this.id,
      required this.title,
      required this.days,
      required this.estimatedTime,
      required this.savedCount,
      required this.isSaved,
      final List<PlaceInItinerary> places = const []})
      : _places = places;

  factory _$ItineraryDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItineraryDetailImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final int days;
  @override
  final int estimatedTime;
  @override
  final int savedCount;
  @override
  final bool isSaved;
  final List<PlaceInItinerary> _places;
  @override
  @JsonKey()
  List<PlaceInItinerary> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  @override
  String toString() {
    return 'ItineraryDetail(id: $id, title: $title, days: $days, estimatedTime: $estimatedTime, savedCount: $savedCount, isSaved: $isSaved, places: $places)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItineraryDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.days, days) || other.days == days) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.savedCount, savedCount) ||
                other.savedCount == savedCount) &&
            (identical(other.isSaved, isSaved) || other.isSaved == isSaved) &&
            const DeepCollectionEquality().equals(other._places, _places));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, days, estimatedTime,
      savedCount, isSaved, const DeepCollectionEquality().hash(_places));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItineraryDetailImplCopyWith<_$ItineraryDetailImpl> get copyWith =>
      __$$ItineraryDetailImplCopyWithImpl<_$ItineraryDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItineraryDetailImplToJson(
      this,
    );
  }
}

abstract class _ItineraryDetail implements ItineraryDetail {
  const factory _ItineraryDetail(
      {required final int id,
      required final String title,
      required final int days,
      required final int estimatedTime,
      required final int savedCount,
      required final bool isSaved,
      final List<PlaceInItinerary> places}) = _$ItineraryDetailImpl;

  factory _ItineraryDetail.fromJson(Map<String, dynamic> json) =
      _$ItineraryDetailImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  int get days;
  @override
  int get estimatedTime;
  @override
  int get savedCount;
  @override
  bool get isSaved;
  @override
  List<PlaceInItinerary> get places;
  @override
  @JsonKey(ignore: true)
  _$$ItineraryDetailImplCopyWith<_$ItineraryDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
