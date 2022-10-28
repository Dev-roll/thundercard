import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/api/firebase_firestore.dart';
import 'package:thundercard/api/my_card_id.dart';

import '../../constants.dart';

class AppTheme extends ChangeNotifier {
  late int appThemeIdx = 0; // 要変更

  void fetchData(String id) {
    FirebaseFirestore.instance
        .collection('cards')
        .doc(id)
        .get()
        .then((snapshot) {
      final card = snapshot.data();
      print('■■■■■■■■■■■■■■■■■■■■■■■■${card?['settings']['app_theme']}');
      change(card?['settings']['app_theme']);
      appThemeIdx = card?['settings']['app_theme'] % 3;
      // currentAppTheme = themeList[appThemeIdx];
    }).catchError((e) {});
    notifyListeners();
  }

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
