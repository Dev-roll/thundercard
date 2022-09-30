import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'api/firebase_auth.dart';
import 'widgets/card_info.dart';
import 'widgets/my_card.dart';
import 'chat.dart';
import 'constants.dart';
import 'custom_progress_indicator.dart';
import 'home_page.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({Key? key, required this.cardId, required this.card})
      : super(key: key);
  final String cardId;
  final dynamic card;

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
    var _usStates = card['is_user']
        ? ["delete this card"]
        : ["edit information", "delete this card"];

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
          'exchanged_cards': FieldValue.arrayRemove([cardId])
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
                title: Text("リンクの削除"),
                content: Text("リンクを削除してもよろしいですか"),
                // (4) ボタンを設定
                actions: [
                  TextButton(
                      onPressed: () => {
                            //  (5) ダイアログを閉じる
                            Navigator.pop(context, false)
                          },
                      child: Text("キャンセル")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        deleteThisCard();
                      },
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
              if (s == 'delete this card') {
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
                  card['is_user']
                      ? Container()
                      : card?['thumbnail'] != null
                          ? Image.network(card?['thumbnail'])
                          : const CustomProgressIndicator(),
                  card['is_user']
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MyCard(
                            cardId: cardId,
                            cardType: CardType.extended,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CardInfo(cardId: cardId, editable: true),
                        ),
                  if (card['is_user'])
                    FutureBuilder(
                      future: getRoom(cardId),
                      builder:
                          (BuildContext context, AsyncSnapshot<Room> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Text("Something went wrong");
                        }

                        // if (snapshot.hasData && !snapshot.data!.exists) {
                        //   return const Text("Document does not exist");
                        // }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    room: snapshot.data!,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Chat'),
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
