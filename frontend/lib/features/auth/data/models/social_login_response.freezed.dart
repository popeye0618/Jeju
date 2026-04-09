// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SocialLoginResponse _$SocialLoginResponseFromJson(Map<String, dynamic> json) {
  return _SocialLoginResponse.fromJson(json);
}

/// @nodoc
mixin _$SocialLoginResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  bool get isNewUser => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialLoginResponseCopyWith<SocialLoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialLoginResponseCopyWith<$Res> {
  factory $SocialLoginResponseCopyWith(
          SocialLoginResponse value, $Res Function(SocialLoginResponse) then) =
      _$SocialLoginResponseCopyWithImpl<$Res, SocialLoginResponse>;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn,
      bool isNewUser});
}

/// @nodoc
class _$SocialLoginResponseCopyWithImpl<$Res, $Val extends SocialLoginResponse>
    implements $SocialLoginResponseCopyWith<$Res> {
  _$SocialLoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? isNewUser = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialLoginResponseImplCopyWith<$Res>
    implements $SocialLoginResponseCopyWith<$Res> {
  factory _$$SocialLoginResponseImplCopyWith(_$SocialLoginResponseImpl value,
          $Res Function(_$SocialLoginResponseImpl) then) =
      __$$SocialLoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn,
      bool isNewUser});
}

/// @nodoc
class __$$SocialLoginResponseImplCopyWithImpl<$Res>
    extends _$SocialLoginResponseCopyWithImpl<$Res, _$SocialLoginResponseImpl>
    implements _$$SocialLoginResponseImplCopyWith<$Res> {
  __$$SocialLoginResponseImplCopyWithImpl(_$SocialLoginResponseImpl _value,
      $Res Function(_$SocialLoginResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? isNewUser = null,
  }) {
    return _then(_$SocialLoginResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialLoginResponseImpl implements _SocialLoginResponse {
  const _$SocialLoginResponseImpl(
      {required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
      required this.expiresIn,
      required this.isNewUser});

  factory _$SocialLoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialLoginResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final String tokenType;
  @override
  final int expiresIn;
  @override
  final bool isNewUser;

  @override
  String toString() {
    return 'SocialLoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, isNewUser: $isNewUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialLoginResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, refreshToken, tokenType, expiresIn, isNewUser);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialLoginResponseImplCopyWith<_$SocialLoginResponseImpl> get copyWith =>
      __$$SocialLoginResponseImplCopyWithImpl<_$SocialLoginResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialLoginResponseImplToJson(
      this,
    );
  }
}

abstract class _SocialLoginResponse implements SocialLoginResponse {
  const factory _SocialLoginResponse(
      {required final String accessToken,
      required final String refreshToken,
      required final String tokenType,
      required final int expiresIn,
      required final bool isNewUser}) = _$SocialLoginResponseImpl;

  factory _SocialLoginResponse.fromJson(Map<String, dynamic> json) =
      _$SocialLoginResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  String get tokenType;
  @override
  int get expiresIn;
  @override
  bool get isNewUser;
  @override
  @JsonKey(ignore: true)
  _$$SocialLoginResponseImplCopyWith<_$SocialLoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
