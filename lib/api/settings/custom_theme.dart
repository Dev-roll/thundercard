import 'package:flutter/material.dart';

import '../../constants.dart';
import './app_theme_storage.dart';
import './card_theme_storage.dart';

class CustomTheme extends ChangeNotifier {
  CustomTheme() {
    _init();
  }

  final AppThemeStorage appThemeStorage = AppThemeStorage();
  final CardThemeStorage cardThemeStorage = CardThemeStorage();

  int appThemeIdx = 0 % 3;
  late int currentAppThemeIdx = appThemeIdx;
  late ThemeMode currentAppTheme = themeList[appThemeIdx];

  int displayCardThemeIdx = 1 % 4;
  late int currentDisplayCardThemeIdx = displayCardThemeIdx;

  void _init() {
    appThemeStorage.readAppTheme().then((value) {
      appThemeIdx = value % 3;
      currentAppThemeIdx = appThemeIdx;
      currentAppTheme = themeList[appThemeIdx];
      notifyListeners();
    });

    cardThemeStorage.readCardTheme().then((value) {
      displayCardThemeIdx = value % 4;
      currentDisplayCardThemeIdx = displayCardThemeIdx;
      notifyListeners();
    });
  }

  void appThemeChange(int i) {
    currentAppThemeIdx = i % 3;
    currentAppTheme = themeList[currentAppThemeIdx];
    notifyListeners();
  }

  void appThemeCancel() {
    currentAppThemeIdx = appThemeIdx;
    currentAppTheme = themeList[currentAppThemeIdx];
    notifyListeners();
  }

  void appThemeUpdate() {
    // TODO: currentAppThemeIdxをデータベースのapp_themeに保存
    appThemeIdx = currentAppThemeIdx;
    appThemeStorage.writeAppTheme(appThemeIdx);
  }

  void cardThemeChange(int i) {
    currentDisplayCardThemeIdx = i % 4;
    notifyListeners();
  }

  void cardThemeCancel() {
    currentDisplayCardThemeIdx = displayCardThemeIdx;
    notifyListeners();
  }

  void cardThemeUpdate() {
    // TODO: currentDisplayCardThemeIdxをデータベースのapp_themeに保存
    displayCardThemeIdx = currentDisplayCardThemeIdx;
    cardThemeStorage.writeCardTheme(displayCardThemeIdx);
  }
}
