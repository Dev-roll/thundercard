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

      // Read the file
      final contents = await file.readAsString();
      print('read -> $contents');

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeAppTheme(int appThemeIdx) async {
    final file = await _localFile;

    print('write -> $appThemeIdx');
    // Write the file
    return file.writeAsString('$appThemeIdx');
  }
}
