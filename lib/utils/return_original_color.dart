int returnOriginalColor(String cardId) {
  // Uint8List list = ascii.encode(cardId);
  // int rdm =
  //     list.reduce((value, element) => ((value << 5) + element) % 4294967295);
  int rdm = cardId.hashCode;
  int colorNum = rdm % 4294967295;
  return colorNum;
}
