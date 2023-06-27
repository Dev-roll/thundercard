import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/providers/exchanged_cards_provider.dart';
import 'package:thundercard/ui/component/search.dart';

class SearchWindow extends ConsumerWidget {
  const SearchWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> exchangedCards = ref.watch(exchangedCardsProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 720,
      ),
      child: Container(
        height: 52,
        margin: EdgeInsets.fromLTRB(
          24,
          16 + MediaQuery.of(context).padding.top,
          24,
          8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Search(exchangedCardIds: exchangedCards),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                child: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: 'カードを検索',
                      filled: true,
                      fillColor: Colors.transparent,
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                    ),
                    onChanged: ((value) {}),
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
