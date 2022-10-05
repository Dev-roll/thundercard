import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

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
    final String? uid = getUid();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var _usStates = widget.card['is_user'] ? ["削除"] : ["編集", "削除"];

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
                    )),
            (_) => false,
          );
          print("DocumentSnapshot successfully updated!");
        }, onError: (e) => print("Error updating document $e"));
      }).catchError((error) => print("Failed to add user: $error"));
    }

    Future _openAlertDialog1(BuildContext context) async {
      // (2) showDialogでダイアログを表示する
      var ret = await showDialog(
          context: context,
          // (3) AlertDialogを作成する
          builder: (context) => AlertDialog(
                title: Text("名刺の削除"),
                content: Text("この名刺を削除しますか？"),
                // (4) ボタンを設定
                actions: [
                  TextButton(
                      onPressed: () => {
                            //  (5) ダイアログを閉じる
                            Navigator.pop(context, false)
                          },
                      onLongPress: null,
                      child: Text("キャンセル")),
                  deleteButtonPressed
                      ? TextButton(
                          onPressed: null,
                          onLongPress: null,
                          child: Container(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                              ),
                              height: 24,
                              width: 24,
                            ),
                            padding: EdgeInsets.all(4),
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
                          child: Text("OK")),
                ],
              ));
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return _usStates.map((String s) {
                return PopupMenuItem(
                  child: Text(s),
                  value: s,
                );
              }).toList();
            },
            onSelected: (String s) {
              if (s == '削除') {
                _openAlertDialog1(context);
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  if (!widget.card['is_user'])
                    widget.card?['thumbnail'] != null
                        ? Image.network(widget.card?['thumbnail'])
                        : const CustomProgressIndicator(),
                  widget.card['is_user']
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MyCard(
                            cardId: widget.cardId,
                            cardType: CardType.extended,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              CardInfo(cardId: widget.cardId, editable: true),
                        ),
                  if (widget.card['is_user'])
                    FutureBuilder(
                      future: getRoom(widget.cardId),
                      builder:
                          (BuildContext context, AsyncSnapshot<Room> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Text("問題が発生しました");
                        }

                        // if (snapshot.hasData && !snapshot.data!.exists) {
                        //   return const Text("Document does not exist");
                        // }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return messageButtonPressed
                              ? ElevatedButton(
                                  onPressed: null,
                                  onLongPress: null,
                                  child: Container(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                      ),
                                      height: 24,
                                      width: 24,
                                    ),
                                    padding: EdgeInsets.all(4),
                                  ),
                                )
                              : ElevatedButton(
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
                                  child: const Text('メッセージ'),
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
