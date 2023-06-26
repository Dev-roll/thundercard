// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserData {
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  ThemeMode get cardThemeMode => throw _privateConstructorUsedError;
  bool get shouldHideOnBoarding => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {ThemeMode themeMode,
      ThemeMode cardThemeMode,
      bool shouldHideOnBoarding});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? cardThemeMode = null,
    Object? shouldHideOnBoarding = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      cardThemeMode: null == cardThemeMode
          ? _value.cardThemeMode
          : cardThemeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      shouldHideOnBoarding: null == shouldHideOnBoarding
          ? _value.shouldHideOnBoarding
          : shouldHideOnBoarding // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserDataCopyWith<$Res> implements $UserDataCopyWith<$Res> {
  factory _$$_UserDataCopyWith(
          _$_UserData value, $Res Function(_$_UserData) then) =
      __$$_UserDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ThemeMode themeMode,
      ThemeMode cardThemeMode,
      bool shouldHideOnBoarding});
}

/// @nodoc
class __$$_UserDataCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$_UserData>
    implements _$$_UserDataCopyWith<$Res> {
  __$$_UserDataCopyWithImpl(
      _$_UserData _value, $Res Function(_$_UserData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? cardThemeMode = null,
    Object? shouldHideOnBoarding = null,
  }) {
    return _then(_$_UserData(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      cardThemeMode: null == cardThemeMode
          ? _value.cardThemeMode
          : cardThemeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      shouldHideOnBoarding: null == shouldHideOnBoarding
          ? _value.shouldHideOnBoarding
          : shouldHideOnBoarding // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_UserData implements _UserData {
  const _$_UserData(
      {required this.themeMode,
      required this.cardThemeMode,
      required this.shouldHideOnBoarding});

  @override
  final ThemeMode themeMode;
  @override
  final ThemeMode cardThemeMode;
  @override
  final bool shouldHideOnBoarding;

  @override
  String toString() {
    return 'UserData(themeMode: $themeMode, cardThemeMode: $cardThemeMode, shouldHideOnBoarding: $shouldHideOnBoarding)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserData &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.cardThemeMode, cardThemeMode) ||
                other.cardThemeMode == cardThemeMode) &&
            (identical(other.shouldHideOnBoarding, shouldHideOnBoarding) ||
                other.shouldHideOnBoarding == shouldHideOnBoarding));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, themeMode, cardThemeMode, shouldHideOnBoarding);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserDataCopyWith<_$_UserData> get copyWith =>
      __$$_UserDataCopyWithImpl<_$_UserData>(this, _$identity);
}

abstract class _UserData implements UserData {
  const factory _UserData(
      {required final ThemeMode themeMode,
      required final ThemeMode cardThemeMode,
      required final bool shouldHideOnBoarding}) = _$_UserData;

  @override
  ThemeMode get themeMode;
  @override
  ThemeMode get cardThemeMode;
  @override
  bool get shouldHideOnBoarding;
  @override
  @JsonKey(ignore: true)
  _$$_UserDataCopyWith<_$_UserData> get copyWith =>
      throw _privateConstructorUsedError;
}
