// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecentPlace _$RecentPlaceFromJson(Map<String, dynamic> json) {
  return _RecentPlace.fromJson(json);
}

/// @nodoc
mixin _$RecentPlace {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String get viewedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecentPlaceCopyWith<RecentPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentPlaceCopyWith<$Res> {
  factory $RecentPlaceCopyWith(
          RecentPlace value, $Res Function(RecentPlace) then) =
      _$RecentPlaceCopyWithImpl<$Res, RecentPlace>;
  @useResult
  $Res call(
      {int id,
      String name,
      String category,
      String? thumbnail,
      String viewedAt});
}

/// @nodoc
class _$RecentPlaceCopyWithImpl<$Res, $Val extends RecentPlace>
    implements $RecentPlaceCopyWith<$Res> {
  _$RecentPlaceCopyWithImpl(this._value, this._then);

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
    Object? thumbnail = freezed,
    Object? viewedAt = null,
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
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      viewedAt: null == viewedAt
          ? _value.viewedAt
          : viewedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentPlaceImplCopyWith<$Res>
    implements $RecentPlaceCopyWith<$Res> {
  factory _$$RecentPlaceImplCopyWith(
          _$RecentPlaceImpl value, $Res Function(_$RecentPlaceImpl) then) =
      __$$RecentPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String category,
      String? thumbnail,
      String viewedAt});
}

/// @nodoc
class __$$RecentPlaceImplCopyWithImpl<$Res>
    extends _$RecentPlaceCopyWithImpl<$Res, _$RecentPlaceImpl>
    implements _$$RecentPlaceImplCopyWith<$Res> {
  __$$RecentPlaceImplCopyWithImpl(
      _$RecentPlaceImpl _value, $Res Function(_$RecentPlaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? thumbnail = freezed,
    Object? viewedAt = null,
  }) {
    return _then(_$RecentPlaceImpl(
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
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      viewedAt: null == viewedAt
          ? _value.viewedAt
          : viewedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentPlaceImpl implements _RecentPlace {
  const _$RecentPlaceImpl(
      {required this.id,
      required this.name,
      required this.category,
      this.thumbnail,
      required this.viewedAt});

  factory _$RecentPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentPlaceImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String category;
  @override
  final String? thumbnail;
  @override
  final String viewedAt;

  @override
  String toString() {
    return 'RecentPlace(id: $id, name: $name, category: $category, thumbnail: $thumbnail, viewedAt: $viewedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentPlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.viewedAt, viewedAt) ||
                other.viewedAt == viewedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, thumbnail, viewedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentPlaceImplCopyWith<_$RecentPlaceImpl> get copyWith =>
      __$$RecentPlaceImplCopyWithImpl<_$RecentPlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentPlaceImplToJson(
      this,
    );
  }
}

abstract class _RecentPlace implements RecentPlace {
  const factory _RecentPlace(
      {required final int id,
      required final String name,
      required final String category,
      final String? thumbnail,
      required final String viewedAt}) = _$RecentPlaceImpl;

  factory _RecentPlace.fromJson(Map<String, dynamic> json) =
      _$RecentPlaceImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get category;
  @override
  String? get thumbnail;
  @override
  String get viewedAt;
  @override
  @JsonKey(ignore: true)
  _$$RecentPlaceImplCopyWith<_$RecentPlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
