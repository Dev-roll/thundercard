import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/providers/exchanged_cards_provider.dart';
import 'package:thundercard/views/widgets/cards_list.dart';
import 'package:thundercard/views/widgets/cards_list_floating_action_button.dart';
import 'package:thundercard/views/widgets/error_message.dart';
import 'package:thundercard/views/widgets/search_window.dart';

class CardsListPage extends ConsumerWidget {
  const CardsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<String>> exchangedCards =
        ref.watch(exchangedCardsStreamProvider);
    return exchangedCards.when(
      loading: () => const Scaffold(
        body: Center(
          // TODO(noname): skeleton
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ),
      error: (error, stackTrace) => ErrorMessage(err: error.toString()),
      data: (exchangedCards) {
        return Scaffold(
          body: Center(
            child: ProviderScope(
              overrides: [
                exchangedCardsProvider.overrideWithValue(exchangedCards),
              ],
              child: const Column(
                children: [
                  SearchWindow(),
                  CardsList(),
                ],
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
