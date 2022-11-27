import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:thundercard/api/colors.dart';

import 'api/firebase_auth.dart';
import 'widgets/card_info.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/my_card.dart';
import 'chat.dart';
import 'constants.dart';
import 'home_page.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({Key? key, required this.cardId, required this.card})
      : super(key: key);
  final String cardId;
  final dynamic card;

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  var deleteButtonPressed = false;
  var messageButtonPressed = false;

  Future<Room> getRoom(String otherCardId) async {
    final String? uid = getUid();
    final DocumentReference user =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final String myCardId = await user.get().then((DocumentSnapshot res) {
      final data = res.data() as Map<String, dynamic>;
      return data['my_cards'][0];
    });
    final DocumentReference card =
        FirebaseFirestore.instance.collection('cards').doc(myCardId);
    final Room room = await card.get().then((DocumentSnapshot res) {
      final data = res.data() as Map<String, dynamic>;
      return Room.fromJson(data['rooms'][otherCardId]);
    });
    return room;
  }

  @override
  Widget build(BuildContext context) {
    // final String? uid = getUid();
    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    void deleteThisCard() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(getUid())
          .get()
          .then((value) {
        final doc = FirebaseFirestore.instance
            .collection('cards')
            .doc(value['my_cards'][0]);
        doc.update({
          'exchanged_cards': FieldValue.arrayRemove([widget.cardId])
        }).then((value) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(
                index: 1,
              ),
            ),
            (_) => false,
          );
          debugPrint('DocumentSnapshot successfully updated!');
        }, onError: (e) => debugPrint('Error updating document $e'));
      }).catchError((error) => debugPrint('Failed to add user: $error'));
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
            deleteButtonPressed
                ? TextButton(
                    onPressed: null,
                    onLongPress: null,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                        ),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        deleteButtonPressed = true;
                      });
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
                  widget.card['is_user']
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height - 200,
                            ),
                            child: FittedBox(
                              child: MyCard(
                                cardId: widget.cardId,
                                cardType: CardType.large,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CardInfo(
                            cardId: widget.cardId,
                            editable: true,
                            isUser: false,
                          ),
                        ),
                  if (!widget.card['is_user'])
                    widget.card?['thumbnail'] != null
                        ? Stack(children: [
                            const CustomProgressIndicator(),
                            Image.network(widget.card?['thumbnail']),
                          ])
                        : const Text('画像が見つかりませんでした'),
                  if (widget.card['is_user'])
                    FutureBuilder(
                      future: getRoom(widget.cardId),
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
                          return messageButtonPressed
                              ? ElevatedButton(
                                  onPressed: null,
                                  onLongPress: null,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                      ),
                                    ),
                                  ),
                                )
                              : ElevatedButton.icon(
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
                                          cardId: widget.cardId,
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
