import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:thundercard/widgets/my_card_data.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.cardId}) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context) {
    Uint8List list = ascii.encode(cardId);
    int rdm =
        list.reduce((value, element) => ((value << 5) + element) % 4294967295);
    int colorNum = (rdm % 4294967295).toInt();
    return Theme(
      data: ThemeData(
        colorSchemeSeed: Color(colorNum),
        brightness: Brightness.light,
      ),
      child: MyCardData(cardId: cardId),
    );
  }
}
