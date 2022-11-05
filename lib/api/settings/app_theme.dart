import 'package:flutter/material.dart';

import '../../constants.dart';
import '../theme_storage.dart';

class AppTheme extends ChangeNotifier {
  AppTheme() {
    _init();
  }

  final ThemeStorage storage = ThemeStorage();

  int appThemeIdx = 0 % 3;
  late int currentAppThemeIdx = appThemeIdx;
  late ThemeMode currentAppTheme = themeList[appThemeIdx];

  void _init() {
    storage.readTheme().then((value) {
      appThemeIdx = value % 3;
      currentAppThemeIdx = appThemeIdx;
      currentAppTheme = themeList[appThemeIdx];
      notifyListeners();
    });
  }

  void change(int i) {
    currentAppThemeIdx = i % 3;
    currentAppTheme = themeList[currentAppThemeIdx];
    notifyListeners();
  }

  void cancel() {
    currentAppThemeIdx = appThemeIdx;
    currentAppTheme = themeList[currentAppThemeIdx];
    notifyListeners();
  }

  void update() {
    // TODO: currentAppThemeIdxをデータベースのapp_themeに保存
    appThemeIdx = currentAppThemeIdx;
    storage.writeTheme(appThemeIdx);
  }
}
