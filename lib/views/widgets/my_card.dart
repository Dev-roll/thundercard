import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/main.dart';
import 'package:thundercard/providers/firebase_firestore.dart';
import 'package:thundercard/utils/constants.dart';
import 'package:thundercard/utils/current_brightness.dart';
import 'package:thundercard/utils/return_original_color.dart';
import 'package:thundercard/views/pages/add_card.dart';
import 'package:thundercard/views/pages/home_page.dart';
import 'package:thundercard/views/widgets/custom_progress_indicator.dart';
import 'package:thundercard/views/widgets/custom_skeletons/skeleton_card.dart';
import 'package:thundercard/views/widgets/custom_skeletons/skeleton_card_large.dart';
import 'package:thundercard/views/widgets/error_message.dart';
import 'package:thundercard/views/widgets/not_found_card.dart';
import 'package:thundercard/views/widgets/positioned_snack_bar.dart';
import 'package:thundercard/views/widgets/preview_card.dart';
import 'package:thundercard/views/widgets/switch_card.dart';

class MyCard extends ConsumerWidget {
  const MyCard({
    Key? key,
    required this.cardId,
    required this.cardType,
    this.light = true,
    this.exchange = false,
    this.pd = 200,
  }) : super(key: key);

  final String cardId;
  final CardType cardType;
  final bool light;
  final bool exchange;
  final double pd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTheme = ref.watch(customThemeProvider);
    if (cardType == CardType.preview) {
      return Theme(
        data: ThemeData(
          colorSchemeSeed:
              light ? const Color(0xFFFF94EF) : const Color(0xFF3986D2),
          brightness: [
            light ? Brightness.light : Brightness.dark,
            currentBrightness(Theme.of(context).colorScheme) == Brightness.light
                ? Brightness.light
                : Brightness.dark,
            Brightness.dark,
            Brightness.light,
          ][customTheme.currentDisplayCardThemeIdx],
          useMaterial3: true,
        ),
        child: PreviewCard(cardId: cardId),
      );
    }
    final currentCardAsyncValue = ref.watch(currentCardStream);
    return currentCardAsyncValue.when(
      error: (err, _) => Text(
        '$err',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      loading: () => const CustomProgressIndicator(),
      data: (currentCard) {
        final currentCardId = currentCard?['current_card'];

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .where('card_id', isEqualTo: cardId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorMessage(err: '問題が発生しました');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              if (cardType == CardType.large) {
                return SkeletonCardLarge(
                  pd: pd,
                );
              }
              return const SkeletonCard();
            }

            dynamic data = snapshot.data;
            final cardIds = data?.docs;
            if (cardIds.length == 0) {
              return Column(
                children: [
                  NotFoundCard(cardId: cardId),
                  if (exchange)
                    Column(
                      children: [
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'ユーザー (@$cardId) が見つからなかったため、交換できません',
                            style: TextStyle(
                              height: 1.6,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomePage();
                                  },
                                ),
                              );
                            }
                          },
                          child: const Text('戻る'),
                        ),
                      ],
                    ),
                ],
              );
            }
            // final account = cardIds[0]?['account'];
            late bool lightTheme;
            try {
              lightTheme = true;
              // lightTheme = cardIds[0]?['visibility']['c10r20u10d10']
              //     ['thundercard']['light_theme'];
              // TODO(noname): firestoreと同期
            } catch (e) {
              debugPrint('$e');
            }

            return Column(
              children: [
                Theme(
                  data: ThemeData(
                    colorSchemeSeed: Color(returnOriginalColor(cardId)),
                    brightness: [
                      lightTheme ? Brightness.light : Brightness.dark,
                      currentBrightness(Theme.of(context).colorScheme) ==
                              Brightness.light
                          ? Brightness.light
                          : Brightness.dark,
                      Brightness.dark,
                      Brightness.light,
                    ][customTheme.currentDisplayCardThemeIdx],
                    useMaterial3: true,
                  ),
                  child: SwitchCard(
                    cardId: cardId,
                    cardType: cardType,
                  ),
                ),
                if (exchange)
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      const Text('カードを交換しますか？'),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return HomePage();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('キャンセル'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.swap_horiz_rounded),
                                  label: const Text('交換'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    applyCard(currentCardId, cardId);
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    } else {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return HomePage();
                                          },
                                        ),
                                      );
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      PositionedSnackBar(
                                        context,
                                        'カード交換を申請しました！',
                                        icon: Icons.hourglass_top_rounded,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
