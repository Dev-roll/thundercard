import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/my_card.dart';

class MyCardDetails extends StatelessWidget {
  const MyCardDetails({super.key, required this.cardId});
  final String cardId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: MyCard(cardId: cardId, cardType: CardType.large),
        ),
      ),
    );
  }
}
