import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exchanged_cards_provider.dart';
import '../../utils/colors.dart';
import 'search.dart';

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
        margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context)
                .push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Search(exchangedCardIds: exchangedCards),
                transitionDuration: const Duration(seconds: 0),
              ),
            )
                .then((value) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor: alphaBlend(
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      Theme.of(context).colorScheme.surface),
                ),
              );
            });
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
