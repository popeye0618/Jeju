// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewItem _$ReviewItemFromJson(Map<String, dynamic> json) {
  return _ReviewItem.fromJson(json);
}

/// @nodoc
mixin _$ReviewItem {
  int get id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  bool get isOwner => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewItemCopyWith<ReviewItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewItemCopyWith<$Res> {
  factory $ReviewItemCopyWith(
          ReviewItem value, $Res Function(ReviewItem) then) =
      _$ReviewItemCopyWithImpl<$Res, ReviewItem>;
  @useResult
  $Res call(
      {int id,
      String nickname,
      double rating,
      String content,
      List<String> imageUrls,
      String createdAt,
      bool isOwner});
}

/// @nodoc
class _$ReviewItemCopyWithImpl<$Res, $Val extends ReviewItem>
    implements $ReviewItemCopyWith<$Res> {
  _$ReviewItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? rating = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? createdAt = null,
    Object? isOwner = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewItemImplCopyWith<$Res>
    implements $ReviewItemCopyWith<$Res> {
  factory _$$ReviewItemImplCopyWith(
          _$ReviewItemImpl value, $Res Function(_$ReviewItemImpl) then) =
      __$$ReviewItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nickname,
      double rating,
      String content,
      List<String> imageUrls,
      String createdAt,
      bool isOwner});
}

/// @nodoc
class __$$ReviewItemImplCopyWithImpl<$Res>
    extends _$ReviewItemCopyWithImpl<$Res, _$ReviewItemImpl>
    implements _$$ReviewItemImplCopyWith<$Res> {
  __$$ReviewItemImplCopyWithImpl(
      _$ReviewItemImpl _value, $Res Function(_$ReviewItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? rating = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? createdAt = null,
    Object? isOwner = null,
  }) {
    return _then(_$ReviewItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewItemImpl implements _ReviewItem {
  const _$ReviewItemImpl(
      {required this.id,
      required this.nickname,
      required this.rating,
      required this.content,
      final List<String> imageUrls = const [],
      required this.createdAt,
      required this.isOwner})
      : _imageUrls = imageUrls;

  factory _$ReviewItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewItemImplFromJson(json);

  @override
  final int id;
  @override
  final String nickname;
  @override
  final double rating;
  @override
  final String content;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  final String createdAt;
  @override
  final bool isOwner;

  @override
  String toString() {
    return 'ReviewItem(id: $id, nickname: $nickname, rating: $rating, content: $content, imageUrls: $imageUrls, createdAt: $createdAt, isOwner: $isOwner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, nickname, rating, content,
      const DeepCollectionEquality().hash(_imageUrls), createdAt, isOwner);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewItemImplCopyWith<_$ReviewItemImpl> get copyWith =>
      __$$ReviewItemImplCopyWithImpl<_$ReviewItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewItemImplToJson(
      this,
    );
  }
}

abstract class _ReviewItem implements ReviewItem {
  const factory _ReviewItem(
      {required final int id,
      required final String nickname,
      required final double rating,
      required final String content,
      final List<String> imageUrls,
      required final String createdAt,
      required final bool isOwner}) = _$ReviewItemImpl;

  factory _ReviewItem.fromJson(Map<String, dynamic> json) =
      _$ReviewItemImpl.fromJson;

  @override
  int get id;
  @override
  String get nickname;
  @override
  double get rating;
  @override
  String get content;
  @override
  List<String> get imageUrls;
  @override
  String get createdAt;
  @override
  bool get isOwner;
  @override
  @JsonKey(ignore: true)
  _$$ReviewItemImplCopyWith<_$ReviewItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
