import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/card_element.dart';
import 'package:thundercard/widgets/extended_card.dart';
import 'package:thundercard/widgets/normal_card.dart';
import 'package:thundercard/widgets/open_app.dart';
import 'package:thundercard/api/return_url.dart';

class SwitchCard extends StatelessWidget {
  const SwitchCard({Key? key, required this.cardId, required this.cardType})
      : super(key: key);
  final String cardId;
  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;

    return cardType == CardType.normal
        ? NormalCard(cardId: cardId)
        : ExtendedCard(cardId: cardId);
  }
}
