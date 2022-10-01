import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:thundercard/api/return_original_color.dart';

import 'switch_card.dart';
import '../constants.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.cardId, required this.cardType})
      : super(key: key);
  final String cardId;
  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorSchemeSeed: Color(returnOriginalColor(cardId)),
        brightness: Brightness.light,
      ),
      child: SwitchCard(
        cardId: cardId,
        cardType: cardType,
      ),
    );
  }
}
