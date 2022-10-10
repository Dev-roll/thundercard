import 'package:flutter/material.dart';

import '../../constants.dart';

class AppTheme extends ChangeNotifier {
  int appThemeIdx = 0 % 3; // 要変更
  // int appThemeIdx = <データベースに記録された値> % 3 に変更する

  late int currentAppThemeIdx = appThemeIdx;
  late ThemeMode currentAppTheme = themeList[appThemeIdx];

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
    // currentAppThemeIdxをデータベースのapp_themeに保存
  }
}
