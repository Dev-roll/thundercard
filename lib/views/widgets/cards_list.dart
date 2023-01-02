import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exchanged_cards_provider.dart';
import '../../utils/constants.dart';
import '../pages/card_details.dart';
import 'my_card.dart';

class CardsList extends ConsumerWidget {
  const CardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> exchangedCards = ref.watch(exchangedCardsProvider);

    return Expanded(
      child: ListView.builder(
        itemCount: exchangedCards.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 16);
          }
          if (index == exchangedCards.length + 1) {
            return const SizedBox(height: 80);
          }
          return Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CardDetails(
                      cardId: exchangedCards[index - 1],
                    ),
                  ));
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                  ),
                  child: FittedBox(
                    child: MyCard(
                      cardId: exchangedCards[index - 1],
                      cardType: CardType.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
