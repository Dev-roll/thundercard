import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppThemeStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/appThemeIdx.txt');
  }

  Future<int> readAppTheme() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeAppTheme(int appThemeIdx) async {
    final file = await _localFile;
    return file.writeAsString('$appThemeIdx');
  }
}
