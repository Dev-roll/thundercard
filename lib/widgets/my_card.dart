import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/api/return_original_color.dart';
import 'package:thundercard/widgets/custom_skeletons/skeleton_card_large.dart';
import 'package:thundercard/widgets/not_found_card.dart';
import 'package:thundercard/widgets/preview_card.dart';
import 'package:thundercard/widgets/custom_skeletons/skeleton_card.dart';

import '../add_card.dart';
import '../api/current_brightness.dart';
import '../api/provider/firebase_firestore.dart';
import '../main.dart';
import 'custom_progress_indicator.dart';
import 'switch_card.dart';
import '../constants.dart';

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
      error: (err, _) => Text(err.toString()), //エラー時
      loading: () => const CustomProgressIndicator(), //読み込み時
      data: (currentCard) {
        return Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('version')
                  .doc('2')
                  .collection('cards')
                  .where('card_id', isEqualTo: cardId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('問題が発生しました');
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
                              width: double.infinity,
                              child: Text(
                                'ユーザー (@$cardId) が見つからなかったため、交換できません',
                                style: const TextStyle(height: 1.6),
                              ),
                            ),
                            const SizedBox(height: 24),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
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
                  // TODO: firestoreと同期
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
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('キャンセル'),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton.icon(
                                      icon:
                                          const Icon(Icons.swap_horiz_rounded),
                                      label: const Text('交換'),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ),
                                      onPressed: () {
                                        handleExchange(currentCard, cardId);
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            elevation: 20,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant,
                                            behavior: SnackBarBehavior.floating,
                                            clipBehavior: Clip.antiAlias,
                                            dismissDirection:
                                                DismissDirection.horizontal,
                                            margin: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  180,
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                            ),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 16, 0),
                                                  child: Icon(Icons
                                                      .file_download_done_rounded),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'カードを交換しました',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground,
                                                        overflow:
                                                            TextOverflow.fade),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // duration: const Duration(seconds: 12),
                                            action: SnackBarAction(
                                              label: 'OK',
                                              onPressed: () {},
                                            ),
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
            ),
          ],
        );
      },
    );
  }
}
