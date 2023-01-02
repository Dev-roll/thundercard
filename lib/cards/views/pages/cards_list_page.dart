import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exchanged_cards_provider.dart';
import '../widgets/cards_list.dart';
import '../widgets/cards_list_floating_action_button.dart';
import '../widgets/search_window.dart';

class CardsListPage extends ConsumerWidget {
  const CardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<String>> exchangedCards =
        ref.watch(exchangedCardsStreamProvider);
    return exchangedCards.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        return const Center(
          child: Text('カードの読み込み中にエラーが発生しました。'),
        );
      },
      data: (exchangedCards) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ProviderScope(
                overrides: [
                  exchangedCardsProvider.overrideWithValue(exchangedCards),
                ],
                child: Column(
                  children: const [
                    SearchWindow(),
                    CardsList(),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: CardsListFloatingActionButton(),
        );
      },
    );
  }
}
