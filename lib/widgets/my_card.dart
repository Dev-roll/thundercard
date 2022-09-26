import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:thundercard/card_details.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/switch_card.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.cardId, required this.cardType})
      : super(key: key);
  final String cardId;
  final CardType cardType;

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
      child: SwitchCard(
        cardId: cardId,
        cardType: cardType,
      ),
    );
  }
}
