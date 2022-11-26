import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/my_card.dart';

class MyCardDetails extends StatelessWidget {
  const MyCardDetails({super.key, required this.cardId});
  final String cardId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  padding: const EdgeInsets.all(20),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: FittedBox(
                      child: MyCard(cardId: cardId, cardType: CardType.large),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
