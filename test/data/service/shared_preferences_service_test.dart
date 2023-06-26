import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thundercard/data/model/user_data.dart';
import 'package:thundercard/data/service/shared_preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('初回起動時にデフォルト値を返す', () async {
    SharedPreferences.setMockInitialValues({});

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferencesService service = SharedPreferencesService(prefs);

    const expectedUserData = UserData(
      themeMode: ThemeMode.system,
      cardThemeMode: ThemeMode.system,
      shouldHideOnBoarding: false,
    );

    expect(service.userData, emits(expectedUserData));
  });

  test('非初回起動時に保存された値を返す', () async {
    const initialValue = {
      'theme_mode': 'dark',
      'card_theme_mode': 'light',
      'should_hide_on_boarding': true,
    };

    SharedPreferences.setMockInitialValues(initialValue);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferencesService service = SharedPreferencesService(prefs);

    const expectedUserData = UserData(
      themeMode: ThemeMode.dark,
      cardThemeMode: ThemeMode.light,
      shouldHideOnBoarding: true,
    );

    expect(service.userData, emits(expectedUserData));
  });

  test('更新後に正しい値を返す', () async {
    SharedPreferences.setMockInitialValues({});

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferencesService service = SharedPreferencesService(prefs);

    const expectedUserDataWhenStarted = UserData(
      themeMode: ThemeMode.system,
      cardThemeMode: ThemeMode.system,
      shouldHideOnBoarding: false,
    );

    const expectedUserDataWhenThemeModeIsLight = UserData(
      themeMode: ThemeMode.light,
      cardThemeMode: ThemeMode.system,
      shouldHideOnBoarding: false,
    );

    const expectedUserDataWhenThemeModeIsDark = UserData(
      themeMode: ThemeMode.dark,
      cardThemeMode: ThemeMode.system,
      shouldHideOnBoarding: false,
    );

    const expectedUserDataWhenCardThemeModeIsLight = UserData(
      themeMode: ThemeMode.dark,
      cardThemeMode: ThemeMode.light,
      shouldHideOnBoarding: false,
    );

    const expectedUserDataWhenCardThemeModeIsDark = UserData(
      themeMode: ThemeMode.dark,
      cardThemeMode: ThemeMode.dark,
      shouldHideOnBoarding: false,
    );

    const expectedUserDataWhenShouldHideOnBoardingIsTrue = UserData(
      themeMode: ThemeMode.dark,
      cardThemeMode: ThemeMode.dark,
      shouldHideOnBoarding: true,
    );

    expect(
      service.userData,
      emitsInOrder([
        expectedUserDataWhenStarted,
        expectedUserDataWhenThemeModeIsLight,
        expectedUserDataWhenThemeModeIsDark,
        expectedUserDataWhenCardThemeModeIsLight,
        expectedUserDataWhenCardThemeModeIsDark,
        expectedUserDataWhenShouldHideOnBoardingIsTrue
      ]),
    );

    // themeModeをlightに設定する
    await service.setThemeMode(ThemeMode.light);

    // themeModeをdarkに設定する
    await service.setThemeMode(ThemeMode.dark);

    // cardThemeModeをlightに設定する
    await service.setCardThemeMode(ThemeMode.light);

    // cardThemeModeをdarkに設定する
    await service.setCardThemeMode(ThemeMode.dark);

    // shouldHideOnBoardingをtrueに設定する
    await service.setShouldHideOnBoarding(true);
  });
}
