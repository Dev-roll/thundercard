import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'large_card.dart';
import 'normal_card.dart';
import 'small_card.dart';

class SwitchCard extends StatelessWidget {
  const SwitchCard(
      {Key? key,
      required this.cardId,
      required this.cardType,
      this.light = true})
      : super(key: key);
  final String cardId;
  final CardType cardType;
  final bool light;

  @override
  Widget build(BuildContext context) {
    switch (cardType) {
      case CardType.small:
        return SmallCard(cardId: cardId);
      case CardType.large:
        return LargeCard(cardId: cardId);
      default:
        return NormalCard(cardId: cardId);
    }
  }
}
