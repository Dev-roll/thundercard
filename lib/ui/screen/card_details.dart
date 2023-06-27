import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/providers/firebase_firestore.dart';
import 'package:thundercard/providers/index.dart';
import 'package:thundercard/ui/component/card_img.dart';
import 'package:thundercard/ui/component/card_info.dart';
import 'package:thundercard/ui/component/custom_progress_indicator.dart';
import 'package:thundercard/ui/component/custom_skeletons/skeleton_card.dart';
import 'package:thundercard/ui/component/error_message.dart';
import 'package:thundercard/ui/component/my_card.dart';
import 'package:thundercard/ui/screen/chat.dart';
import 'package:thundercard/ui/screen/home_page.dart';
import 'package:thundercard/utils/constants.dart';

class CardDetails extends ConsumerWidget {
  const CardDetails({Key? key, required this.cardId}) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c21r20u00d11AsyncValue = ref.watch(c21r20u00d11Stream(cardId));
    return c21r20u00d11AsyncValue.when(
      error: (err, _) => ErrorMessage(err: '$err'),
      loading: () => const Scaffold(
        body: Center(
          child: SkeletonCard(),
        ),
      ),
      data: (c21r20u00d11) {
        final currentCardAsyncValue = ref.watch(currentCardStream);
        return currentCardAsyncValue.when(
          error: (err, _) => ErrorMessage(err: '$err'),
          loading: () => const Scaffold(
            body: Center(
              child: SkeletonCard(),
            ),
          ),
          data: (currentCard) {
            final currentCardId = currentCard?['current_card'];
            final bool isUser = c21r20u00d11?['is_user'];
            Future<Room> getRoom(String otherCardId) async {
              final DocumentReference rooms = FirebaseFirestore.instance
                  .collection('version')
                  .doc('2')
                  .collection('cards')
                  .doc(currentCardId)
                  .collection('visibility')
                  .doc('c10r21u21d10');

              final Room room = await rooms.get().then((DocumentSnapshot res) {
                final data = res.data() as Map<String, dynamic>;
                return Room.fromJson(data['rooms'][otherCardId]);
              });
              return room;
            }

            void deleteThisCard() {
              FirebaseFirestore.instance
                  .collection('version')
                  .doc('2')
                  .collection('cards')
                  .doc(currentCardId)
                  .collection('visibility')
                  .doc('c10r10u11d10')
                  .update({
                'exchanged_cards': FieldValue.arrayRemove([cardId])
              }).then(
                (value) {
                  ref.watch(currentIndexProvider.notifier).state = 1;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (_) => false,
                  );
                  debugPrint('DocumentSnapshot successfully updated!');
                },
                onError: (e) {
                  debugPrint('Error updating document $e');
                },
              );
            }

            Future openAlertDialog1(BuildContext context) async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const Icon(Icons.delete_rounded),
                  title: const Text('カードの削除'),
                  content: Text(
                    'このカードを削除しますか？',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        deleteThisCard();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    splashRadius: 20,
                    elevation: 8,
                    position: PopupMenuPosition.under,
                    itemBuilder: (BuildContext context) {
                      return menuItmCardDetails.map((String s) {
                        return PopupMenuItem(
                          value: s,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              menuIcnCardDetails[menuItmCardDetails.indexOf(s)],
                              const SizedBox(width: 8),
                              Text(
                                s,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    onSelected: (String s) {
                      if (s == '削除') {
                        openAlertDialog1(context);
                      }
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        isUser
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height -
                                            200,
                                  ),
                                  child: FittedBox(
                                    child: MyCard(
                                      cardId: cardId,
                                      cardType: CardType.large,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CardInfo(
                                  cardId: cardId,
                                  editable: true,
                                  isUser: false,
                                ),
                              ),
                        if (!isUser) CardImg(cardId: cardId),
                        if (isUser)
                          FutureBuilder(
                            future: getRoom(cardId),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<Room> snapshot,
                            ) {
                              if (snapshot.hasError) {
                                debugPrint('${snapshot.error}');
                                return const Text('問題が発生しました');
                              }

                              // if (snapshot.hasData && !snapshot.data!.exists) {
                              //   return const Text('Document does not exist');
                              // }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ElevatedButton.icon(
                                  icon:
                                      const Icon(Icons.question_answer_rounded),
                                  label: const Text('メッセージ'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          room: snapshot.data!,
                                          cardId: cardId,
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: null,
                                );
                              }
                              return const Center(
                                child: CustomProgressIndicator(),
                              );
                            },
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 32,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
