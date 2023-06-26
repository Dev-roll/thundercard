import 'package:flutter/material.dart';
import 'package:thundercard/data/model/user_data.dart';
import 'package:thundercard/data/repository/user_data_repository.dart';
import 'package:thundercard/data/service/shared_preferences_service.dart';

class LocalUserDataRepository implements UserDataRepository {
  final SharedPreferencesService _sharedPreferencesService;

  LocalUserDataRepository(this._sharedPreferencesService);

  @override
  Stream<UserData> get userData => _sharedPreferencesService.userData;

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _sharedPreferencesService.setThemeMode(themeMode);
  }

  @override
  Future<void> setCardThemeMode(ThemeMode cardThemeMode) async {
    await _sharedPreferencesService.setCardThemeMode(cardThemeMode);
  }

  @override
  Future<void> setShouldHideOnBoarding(bool shouldHideOnBoarding) async {
    await _sharedPreferencesService
        .setShouldHideOnBoarding(shouldHideOnBoarding);
  }
}
