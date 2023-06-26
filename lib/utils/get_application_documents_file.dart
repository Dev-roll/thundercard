import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<File> getApplicationDocumentsFile(
  String text,
  List<int> imageData,
) async {
  final directory = await getApplicationDocumentsDirectory();

  final exportFile = File('${directory.path}/$text.png');
  if (!await exportFile.exists()) {
    await exportFile.create(recursive: true);
  }
  final file = await exportFile.writeAsBytes(imageData);
  return file;
}
