import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CardThemeStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/displayCardThemeIdx.txt');
  }

  Future<int> readCardTheme() async {
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

  Future<File> writeCardTheme(int displayCardThemeIdx) async {
    final file = await _localFile;

    print('write -> $displayCardThemeIdx');
    // Write the file
    return file.writeAsString('$displayCardThemeIdx');
  }
}
