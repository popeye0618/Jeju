// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaceDetail _$PlaceDetailFromJson(Map<String, dynamic> json) {
  return _PlaceDetail.fromJson(json);
}

/// @nodoc
mixin _$PlaceDetail {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  bool get hasRamp => throw _privateConstructorUsedError;
  bool get hasElevator => throw _privateConstructorUsedError;
  bool get hasAccessibleToilet => throw _privateConstructorUsedError;
  bool get hasRestZone => throw _privateConstructorUsedError;
  bool get hasAccessibleParking => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  String? get tel => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  String? get openTime => throw _privateConstructorUsedError;
  String? get closeTime => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  double get avgRating => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceDetailCopyWith<PlaceDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceDetailCopyWith<$Res> {
  factory $PlaceDetailCopyWith(
          PlaceDetail value, $Res Function(PlaceDetail) then) =
      _$PlaceDetailCopyWithImpl<$Res, PlaceDetail>;
  @useResult
  $Res call(
      {int id,
      String name,
      String category,
      String address,
      String? thumbnail,
      bool hasRamp,
      bool hasElevator,
      bool hasAccessibleToilet,
      bool hasRestZone,
      bool hasAccessibleParking,
      bool isLiked,
      String? tel,
      double lat,
      double lng,
      String? openTime,
      String? closeTime,
      List<String> images,
      int reviewCount,
      double avgRating});
}

/// @nodoc
class _$PlaceDetailCopyWithImpl<$Res, $Val extends PlaceDetail>
    implements $PlaceDetailCopyWith<$Res> {
  _$PlaceDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? address = null,
    Object? thumbnail = freezed,
    Object? hasRamp = null,
    Object? hasElevator = null,
    Object? hasAccessibleToilet = null,
    Object? hasRestZone = null,
    Object? hasAccessibleParking = null,
    Object? isLiked = null,
    Object? tel = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? images = null,
    Object? reviewCount = null,
    Object? avgRating = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      hasRamp: null == hasRamp
          ? _value.hasRamp
          : hasRamp // ignore: cast_nullable_to_non_nullable
              as bool,
      hasElevator: null == hasElevator
          ? _value.hasElevator
          : hasElevator // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccessibleToilet: null == hasAccessibleToilet
          ? _value.hasAccessibleToilet
          : hasAccessibleToilet // ignore: cast_nullable_to_non_nullable
              as bool,
      hasRestZone: null == hasRestZone
          ? _value.hasRestZone
          : hasRestZone // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccessibleParking: null == hasAccessibleParking
          ? _value.hasAccessibleParking
          : hasAccessibleParking // ignore: cast_nullable_to_non_nullable
              as bool,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      tel: freezed == tel
          ? _value.tel
          : tel // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceDetailImplCopyWith<$Res>
    implements $PlaceDetailCopyWith<$Res> {
  factory _$$PlaceDetailImplCopyWith(
          _$PlaceDetailImpl value, $Res Function(_$PlaceDetailImpl) then) =
      __$$PlaceDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String category,
      String address,
      String? thumbnail,
      bool hasRamp,
      bool hasElevator,
      bool hasAccessibleToilet,
      bool hasRestZone,
      bool hasAccessibleParking,
      bool isLiked,
      String? tel,
      double lat,
      double lng,
      String? openTime,
      String? closeTime,
      List<String> images,
      int reviewCount,
      double avgRating});
}

/// @nodoc
class __$$PlaceDetailImplCopyWithImpl<$Res>
    extends _$PlaceDetailCopyWithImpl<$Res, _$PlaceDetailImpl>
    implements _$$PlaceDetailImplCopyWith<$Res> {
  __$$PlaceDetailImplCopyWithImpl(
      _$PlaceDetailImpl _value, $Res Function(_$PlaceDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? address = null,
    Object? thumbnail = freezed,
    Object? hasRamp = null,
    Object? hasElevator = null,
    Object? hasAccessibleToilet = null,
    Object? hasRestZone = null,
    Object? hasAccessibleParking = null,
    Object? isLiked = null,
    Object? tel = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? images = null,
    Object? reviewCount = null,
    Object? avgRating = null,
  }) {
    return _then(_$PlaceDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      hasRamp: null == hasRamp
          ? _value.hasRamp
          : hasRamp // ignore: cast_nullable_to_non_nullable
              as bool,
      hasElevator: null == hasElevator
          ? _value.hasElevator
          : hasElevator // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccessibleToilet: null == hasAccessibleToilet
          ? _value.hasAccessibleToilet
          : hasAccessibleToilet // ignore: cast_nullable_to_non_nullable
              as bool,
      hasRestZone: null == hasRestZone
          ? _value.hasRestZone
          : hasRestZone // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccessibleParking: null == hasAccessibleParking
          ? _value.hasAccessibleParking
          : hasAccessibleParking // ignore: cast_nullable_to_non_nullable
              as bool,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      tel: freezed == tel
          ? _value.tel
          : tel // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceDetailImpl implements _PlaceDetail {
  const _$PlaceDetailImpl(
      {required this.id,
      required this.name,
      required this.category,
      required this.address,
      this.thumbnail,
      required this.hasRamp,
      required this.hasElevator,
      required this.hasAccessibleToilet,
      required this.hasRestZone,
      required this.hasAccessibleParking,
      required this.isLiked,
      this.tel,
      required this.lat,
      required this.lng,
      this.openTime,
      this.closeTime,
      final List<String> images = const [],
      required this.reviewCount,
      required this.avgRating})
      : _images = images;

  factory _$PlaceDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceDetailImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String category;
  @override
  final String address;
  @override
  final String? thumbnail;
  @override
  final bool hasRamp;
  @override
  final bool hasElevator;
  @override
  final bool hasAccessibleToilet;
  @override
  final bool hasRestZone;
  @override
  final bool hasAccessibleParking;
  @override
  final bool isLiked;
  @override
  final String? tel;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final String? openTime;
  @override
  final String? closeTime;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final int reviewCount;
  @override
  final double avgRating;

  @override
  String toString() {
    return 'PlaceDetail(id: $id, name: $name, category: $category, address: $address, thumbnail: $thumbnail, hasRamp: $hasRamp, hasElevator: $hasElevator, hasAccessibleToilet: $hasAccessibleToilet, hasRestZone: $hasRestZone, hasAccessibleParking: $hasAccessibleParking, isLiked: $isLiked, tel: $tel, lat: $lat, lng: $lng, openTime: $openTime, closeTime: $closeTime, images: $images, reviewCount: $reviewCount, avgRating: $avgRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.hasRamp, hasRamp) || other.hasRamp == hasRamp) &&
            (identical(other.hasElevator, hasElevator) ||
                other.hasElevator == hasElevator) &&
            (identical(other.hasAccessibleToilet, hasAccessibleToilet) ||
                other.hasAccessibleToilet == hasAccessibleToilet) &&
            (identical(other.hasRestZone, hasRestZone) ||
                other.hasRestZone == hasRestZone) &&
            (identical(other.hasAccessibleParking, hasAccessibleParking) ||
                other.hasAccessibleParking == hasAccessibleParking) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.tel, tel) || other.tel == tel) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        category,
        address,
        thumbnail,
        hasRamp,
        hasElevator,
        hasAccessibleToilet,
        hasRestZone,
        hasAccessibleParking,
        isLiked,
        tel,
        lat,
        lng,
        openTime,
        closeTime,
        const DeepCollectionEquality().hash(_images),
        reviewCount,
        avgRating
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceDetailImplCopyWith<_$PlaceDetailImpl> get copyWith =>
      __$$PlaceDetailImplCopyWithImpl<_$PlaceDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceDetailImplToJson(
      this,
    );
  }
}

abstract class _PlaceDetail implements PlaceDetail {
  const factory _PlaceDetail(
      {required final int id,
      required final String name,
      required final String category,
      required final String address,
      final String? thumbnail,
      required final bool hasRamp,
      required final bool hasElevator,
      required final bool hasAccessibleToilet,
      required final bool hasRestZone,
      required final bool hasAccessibleParking,
      required final bool isLiked,
      final String? tel,
      required final double lat,
      required final double lng,
      final String? openTime,
      final String? closeTime,
      final List<String> images,
      required final int reviewCount,
      required final double avgRating}) = _$PlaceDetailImpl;

  factory _PlaceDetail.fromJson(Map<String, dynamic> json) =
      _$PlaceDetailImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get category;
  @override
  String get address;
  @override
  String? get thumbnail;
  @override
  bool get hasRamp;
  @override
  bool get hasElevator;
  @override
  bool get hasAccessibleToilet;
  @override
  bool get hasRestZone;
  @override
  bool get hasAccessibleParking;
  @override
  bool get isLiked;
  @override
  String? get tel;
  @override
  double get lat;
  @override
  double get lng;
  @override
  String? get openTime;
  @override
  String? get closeTime;
  @override
  List<String> get images;
  @override
  int get reviewCount;
  @override
  double get avgRating;
  @override
  @JsonKey(ignore: true)
  _$$PlaceDetailImplCopyWith<_$PlaceDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
