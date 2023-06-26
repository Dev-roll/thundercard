import 'package:flutter/material.dart';
import 'package:thundercard/data/model/user_data.dart';

abstract class UserDataRepository {
  Stream<UserData> get userData;

  Future<void> setThemeMode(ThemeMode themeMode);

  Future<void> setCardThemeMode(ThemeMode cardThemeMode);

  Future<void> setShouldHideOnBoarding(bool shouldHideOnBoarding);
}
