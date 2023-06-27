import 'package:flutter/material.dart';
import 'package:thundercard/ui/component/my_card.dart';
import 'package:thundercard/utils/constants.dart';

class MyCardDetails extends StatelessWidget {
  const MyCardDetails({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          0,
          MediaQuery.of(context).padding.bottom,
        ),
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
                      maxHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          100,
                    ),
                    child: FittedBox(
                      child: MyCard(
                        cardId: cardId,
                        cardType: CardType.large,
                        pd: 100,
                      ),
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
