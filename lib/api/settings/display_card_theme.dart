import 'package:flutter/material.dart';

import '../../constants.dart';

class DisplayCardTheme extends ChangeNotifier {
  int displayCardThemeIdx = 0 % 4; // 要変更
  // int displayCardThemeIdx = <データベースに記録された値> % 4 に変更する

  late int currentDisplayCardThemeIdx = displayCardThemeIdx;

  void update(int i) {
    currentDisplayCardThemeIdx = i % 4;
    notifyListeners();
    // currentDisplayCardThemeIdxをデータベースのapp_themeに保存
  }
}
// class DisplayCardTheme extends ChangeNotifier {
//   int displayCardThemeIdx = 0 % 4; // 要変更
//   // int displayCardThemeIdx = <データベースに記録された値> % 4 に変更する

//   late int currentDisplayCardThemeIdx = displayCardThemeIdx;

//   void change(int i) {
//     currentDisplayCardThemeIdx = i % 4;
//     notifyListeners();
//   }

//   void cancel() {
//     currentDisplayCardThemeIdx = displayCardThemeIdx;
//     notifyListeners();
//   }

//   void update() {
//     // currentDisplayCardThemeIdxをデータベースのapp_themeに保存
//   }
// }
