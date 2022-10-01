import 'dart:convert';
import 'dart:typed_data';

int returnOriginalColor(String cardId) {
  Uint8List list = ascii.encode(cardId);
  int rdm =
      list.reduce((value, element) => ((value << 5) + element) % 4294967295);
  int colorNum = (rdm % 4294967295).toInt();
  return colorNum;
}
