import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/api/return_original_color.dart';
import 'package:thundercard/widgets/not_found_card.dart';
import 'package:thundercard/widgets/preview_card.dart';
import 'package:thundercard/widgets/custom_skeletons/skeleton_card.dart';

import '../add_card.dart';
import '../api/current_brightness.dart';
import '../api/firebase_auth.dart';
import '../api/settings/display_card_theme.dart';
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
  }) : super(key: key);

  final String cardId;
  final CardType cardType;
  final bool light;
  final bool exchange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayCardTheme = ref.watch(displayCardThemeProvider);
    CollectionReference? users;
    String? uid;
    if (cardType == CardType.preview) {
      return Theme(
        data: ThemeData(
          colorSchemeSeed: Color(returnOriginalColor(cardId)),
          brightness: [
            light ? Brightness.light : Brightness.dark,
            currentBrightness(Theme.of(context).colorScheme) == Brightness.light
                ? Brightness.light
                : Brightness.dark,
            Brightness.dark,
            Brightness.light,
          ][displayCardTheme.currentDisplayCardThemeIdx],
        ),
        child: PreviewCard(cardId: cardId),
      );
    }
    if (exchange) {
      users = FirebaseFirestore.instance.collection('users');
      uid = getUid();
    }
    return Column(
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cards')
              .where('card_id', isEqualTo: cardId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('問題が発生しました');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonCard();
            }

            dynamic data = snapshot.data;
            final cardIds = data?.docs;
            if (cardIds.length == 0) {
              return Column(
                children: [
                  Container(
                    child: NotFoundCard(cardId: cardId),
                  ),
                  if (exchange)
                    Column(
                      children: [
                        const SizedBox(height: 32),
                        Container(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                          width: double.infinity,
                          child: Text(
                            'ユーザー (@$cardId) が見つからなかったため、交換できません',
                            style: TextStyle(height: 1.6),
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
            final account = cardIds[0]?['account'];
            late bool lightTheme;
            try {
              lightTheme = true;
              lightTheme = cardIds[0]?['thundercard']?['light_theme'];
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
                    ][displayCardTheme.currentDisplayCardThemeIdx],
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
                          FutureBuilder(
                            future: users?.doc(uid).get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('問題が発生しました');
                              }
                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return const Text('ユーザー情報の取得に失敗しました');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> user = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                String myCardId = user['my_cards'][0];
                                return Center(
                                  child: Row(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('キャンセル'),
                                      ),
                                      SizedBox(width: 16),
                                      ElevatedButton.icon(
                                        icon: Icon(Icons.swap_horiz_rounded),
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
                                          handleExchange(myCardId, cardId);
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              elevation: 20,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceVariant,
                                              behavior:
                                                  SnackBarBehavior.floating,
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
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 16, 0),
                                                    child: Icon(Icons
                                                        .file_download_done_rounded),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'カードを交換しました',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          overflow: TextOverflow
                                                              .fade),
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
                                );
                              }
                              return const CustomProgressIndicator();
                            },
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
  }
}
