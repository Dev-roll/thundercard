import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required ThemeMode themeMode,
    required ThemeMode cardThemeMode,
    required bool shouldHideOnBoarding,
  }) = _UserData;
}
