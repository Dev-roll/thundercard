import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exchanged_cards_provider.dart';
import '../../utils/constants.dart';
import '../pages/card_details.dart';
import 'my_card.dart';

class CardsList extends ConsumerWidget {
  const CardsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> exchangedCards = ref.watch(exchangedCardsProvider);

    return Expanded(
      child: (exchangedCards.isNotEmpty)
          ? ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 80),
              itemCount: exchangedCards.length,
              itemBuilder: (context, index) {
                final cardIndex = exchangedCards.length - 1 - index;
                return Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CardDetails(
                            cardId: exchangedCards[cardIndex],
                          ),
                        ));
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                        ),
                        child: FittedBox(
                          child: MyCard(
                            cardId: exchangedCards[cardIndex],
                            cardType: CardType.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.priority_high_rounded,
                  size: 120,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                Text(
                  'まだカードがありません',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
    );
  }
}
