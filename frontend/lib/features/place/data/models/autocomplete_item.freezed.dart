// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'autocomplete_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AutocompleteItem _$AutocompleteItemFromJson(Map<String, dynamic> json) {
  return _AutocompleteItem.fromJson(json);
}

/// @nodoc
mixin _$AutocompleteItem {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AutocompleteItemCopyWith<AutocompleteItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutocompleteItemCopyWith<$Res> {
  factory $AutocompleteItemCopyWith(
          AutocompleteItem value, $Res Function(AutocompleteItem) then) =
      _$AutocompleteItemCopyWithImpl<$Res, AutocompleteItem>;
  @useResult
  $Res call({int id, String name, String category});
}

/// @nodoc
class _$AutocompleteItemCopyWithImpl<$Res, $Val extends AutocompleteItem>
    implements $AutocompleteItemCopyWith<$Res> {
  _$AutocompleteItemCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AutocompleteItemImplCopyWith<$Res>
    implements $AutocompleteItemCopyWith<$Res> {
  factory _$$AutocompleteItemImplCopyWith(_$AutocompleteItemImpl value,
          $Res Function(_$AutocompleteItemImpl) then) =
      __$$AutocompleteItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String category});
}

/// @nodoc
class __$$AutocompleteItemImplCopyWithImpl<$Res>
    extends _$AutocompleteItemCopyWithImpl<$Res, _$AutocompleteItemImpl>
    implements _$$AutocompleteItemImplCopyWith<$Res> {
  __$$AutocompleteItemImplCopyWithImpl(_$AutocompleteItemImpl _value,
      $Res Function(_$AutocompleteItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
  }) {
    return _then(_$AutocompleteItemImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AutocompleteItemImpl implements _AutocompleteItem {
  const _$AutocompleteItemImpl(
      {required this.id, required this.name, required this.category});

  factory _$AutocompleteItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutocompleteItemImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String category;

  @override
  String toString() {
    return 'AutocompleteItem(id: $id, name: $name, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutocompleteItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AutocompleteItemImplCopyWith<_$AutocompleteItemImpl> get copyWith =>
      __$$AutocompleteItemImplCopyWithImpl<_$AutocompleteItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AutocompleteItemImplToJson(
      this,
    );
  }
}

abstract class _AutocompleteItem implements AutocompleteItem {
  const factory _AutocompleteItem(
      {required final int id,
      required final String name,
      required final String category}) = _$AutocompleteItemImpl;

  factory _AutocompleteItem.fromJson(Map<String, dynamic> json) =
      _$AutocompleteItemImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get category;
  @override
  @JsonKey(ignore: true)
  _$$AutocompleteItemImplCopyWith<_$AutocompleteItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
