import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thundercard/data/model/user_data.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;
  final StreamController<UserData> _userDataController =
      StreamController<UserData>();

  SharedPreferencesService(this._sharedPreferences) {
    _load();
  }

  Stream<UserData> get userData => _userDataController.stream;

  Future<void> _load() async {
    _userDataController.add(
      UserData(
        themeMode: () {
          switch (_sharedPreferences.getString('theme_mode')) {
            case 'system':
              return ThemeMode.system;
            case 'light':
              return ThemeMode.light;
            case 'dark':
              return ThemeMode.dark;
            default:
              return ThemeMode.system;
          }
        }(),
        cardThemeMode: () {
          switch (_sharedPreferences.getString('card_theme_mode')) {
            case 'system':
              return ThemeMode.system;
            case 'light':
              return ThemeMode.light;
            case 'dark':
              return ThemeMode.dark;
            default:
              return ThemeMode.system;
          }
        }(),
        shouldHideOnBoarding: () {
          // TODO(keigomichi): initial value should be true for initial user.
          return _sharedPreferences.getBool('should_hide_on_boarding') ?? false;
        }(),
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    switch (themeMode) {
      case ThemeMode.system:
        await _sharedPreferences.setString('theme_mode', 'system');
        break;
      case ThemeMode.light:
        await _sharedPreferences.setString('theme_mode', 'light');
        break;
      case ThemeMode.dark:
        await _sharedPreferences.setString('theme_mode', 'dark');
        break;
    }

    await _load();
  }

  Future<void> setCardThemeMode(ThemeMode cardThemeMode) async {
    switch (cardThemeMode) {
      case ThemeMode.system:
        await _sharedPreferences.setString('card_theme_mode', 'system');
        break;
      case ThemeMode.light:
        await _sharedPreferences.setString('card_theme_mode', 'light');
        break;
      case ThemeMode.dark:
        await _sharedPreferences.setString('card_theme_mode', 'dark');
        break;
    }

    await _load();
  }

  Future<void> setShouldHideOnBoarding(bool shouldHideOnBoarding) async {
    await _sharedPreferences.setBool(
      'should_hide_on_boarding',
      shouldHideOnBoarding,
    );

    await _load();
  }

  void dispose() {
    _userDataController.close();
  }
}
