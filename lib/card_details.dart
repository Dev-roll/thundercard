import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/api/colors.dart';
import 'package:thundercard/widgets/preview_img.dart';

import 'api/firebase_auth.dart';
import 'api/provider/index.dart';
import 'widgets/card_info.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/my_card.dart';
import 'chat.dart';
import 'constants.dart';
import 'home_page.dart';

class CardDetails extends ConsumerWidget {
  CardDetails({Key? key, required this.cardId, required this.card})
      : super(key: key);
  final String cardId;
  final dynamic card;

  final String? uid = getUid();

  Future<Room> getRoom(String otherCardId) async {
    final DocumentReference currentCard = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('card')
        .doc('current_card');
    final String myCardId =
        await currentCard.get().then((DocumentSnapshot res) {
      final data = res.data() as Map<String, dynamic>;
      return data['current_card'];
    });
    final DocumentReference rooms = FirebaseFirestore.instance
        .collection('version')
        .doc('2')
        .collection('cards')
        .doc(myCardId)
        .collection('visibility')
        .doc('c10r21u21d10');

    final Room room = await rooms.get().then((DocumentSnapshot res) {
      final data = res.data() as Map<String, dynamic>;
      return Room.fromJson(data['rooms'][otherCardId]);
    });
    return room;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final String? uid = getUid();
    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    void deleteThisCard() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('card')
          .doc('current_card')
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('version')
            .doc('2')
            .collection('cards')
            .doc(value['current_card'])
            .collection('visibility')
            .doc('c10r10u11d10')
            .update({
          'exchanged_cards': FieldValue.arrayRemove([cardId])
        }).then((value) {
          ref.watch(currentIndexProvider.notifier).state = 1;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (_) => false,
          );
          debugPrint('DocumentSnapshot successfully updated!');
        }, onError: (e) {
          debugPrint('Error updating document $e');
        });
      }).catchError((error) {
        debugPrint('Failed to add user: $error');
      });
    }

    Future openAlertDialog1(BuildContext context) async {
      // (2) showDialogでダイアログを表示する
      await showDialog(
        context: context,
        // (3) AlertDialogを作成する
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.delete_rounded),
          title: const Text('カードの削除'),
          content: Text(
            'このカードを削除しますか？',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          // (4) ボタンを設定
          actions: [
            TextButton(
              onPressed: () => {
                //  (5) ダイアログを閉じる
                Navigator.pop(context, false)
              },
              onLongPress: null,
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
                deleteThisCard();
              },
              onLongPress: null,
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
            color: alphaBlend(
              Theme.of(context).colorScheme.primary.withOpacity(0.08),
              Theme.of(context).colorScheme.surface,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                          color: Theme.of(context).colorScheme.onSurface,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  card['is_user']
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height - 200,
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
                  if (!card['is_user'])
                    card?['thumbnail'] != null
                        ? Stack(
                            children: [
                              const CustomProgressIndicator(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return PreviewImg(
                                        image: Image.network(
                                          card?['thumbnail'],
                                        ),
                                      );
                                    }),
                                  );
                                },
                                child: Hero(
                                  tag: 'card_image',
                                  child: Image.network(
                                    card?['thumbnail'],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Text('画像が見つかりませんでした'),
                  if (card['is_user'])
                    FutureBuilder(
                      future: getRoom(cardId),
                      builder:
                          (BuildContext context, AsyncSnapshot<Room> snapshot) {
                        if (snapshot.hasError) {
                          debugPrint('${snapshot.error}');
                          return const Text('問題が発生しました');
                        }

                        // if (snapshot.hasData && !snapshot.data!.exists) {
                        //   return const Text('Document does not exist');
                        // }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.question_answer_rounded),
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
                        return const Center(child: CustomProgressIndicator());
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
