import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:intl/intl.dart';

import 'api/firebase_auth.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/my_card.dart';
import 'constants.dart';
import 'home_page.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key, required this.myCardId, required this.cardId})
      : super(key: key);
  final myCardId;
  final String cardId;

  @override
  State<AddCard> createState() => _AddCardState();
}

void handleExchange(String myCardId, anotherCardId) async {
  final DocumentReference myCard =
      FirebaseFirestore.instance.collection('cards').doc(myCardId);
  final DocumentReference anotherCard =
      FirebaseFirestore.instance.collection('cards').doc(anotherCardId);
  final String anotherUid =
      await anotherCard.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['uid'];
  });
  final Room room = await FirebaseChatCore.instance
      .createRoom(User.fromJson({'id': anotherUid}));

  myCard.update({
    'exchanged_cards': FieldValue.arrayUnion([anotherCardId]),
    'rooms.$anotherCardId': room.toJson()
  }).then((value) => print("DocumentSnapshot successfully updated"),
      onError: (e) => print("Error updating document $e"));
  anotherCard.update({
    'exchanged_cards': FieldValue.arrayUnion([myCardId]),
    'rooms.$myCardId': room.toJson()
  }).then((value) => print("DocumentSnapshot successfully updated"),
      onError: (e) => print("Error updating document $e"));

  final addMyNotificationData = {
    'title': 'カードリスト追加のお知らせ',
    'content': '@$myCardIdさんのカードリストに@$anotherCardIdさんが追加されました！',
    'created_at': DateTime.now(),
    'read': false,
    'tags': ['interaction'],
    'notification_id':
        'list-add-$myCardId-${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}',
  };

  FirebaseFirestore.instance
      .collection('cards')
      .doc(myCardId)
      .collection('notifications')
      .add(addMyNotificationData);

  final addAnotherNotificationData = {
    'title': 'カードリスト追加のお知らせ',
    'content': '@$anotherCardIdさんのカードリストに@$myCardIdさんが追加されました！',
    'created_at': DateTime.now(),
    'read': false,
    'tags': ['interaction'],
    'notification_id':
        'list-add-$anotherCardId-${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}',
  };

  FirebaseFirestore.instance
      .collection('cards')
      .doc(anotherCardId)
      .collection('notifications')
      .add(addAnotherNotificationData);
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    final myCardId = widget.myCardId;
    final String addCardId = widget.cardId;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final String? uid = getUid();

    return Scaffold(
      appBar: AppBar(title: Text('カードを追加')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                MyCard(
                  cardId: addCardId,
                  cardType: CardType.normal,
                ),
                SizedBox(height: 32),
                addCardId == myCardId
                    ? Column(
                        children: [
                          Text('ユーザー自身のカードは追加できません'),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text('このカードを追加しますか？'),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: users.doc(uid).get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('問題が発生しました');
                                  }
                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
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
                                          ElevatedButton(
                                            onPressed: () {
                                              handleExchange(
                                                  myCardId, addCardId);
                                              // Navigator.of(context).push(
                                              //   MaterialPageRoute(
                                              //     builder: (context) => HomePage(index: 1),
                                              //   ),
                                              // );
                                              // Navigator.of(context).pushAndRemoveUntil(
                                              //   MaterialPageRoute(
                                              //     builder: (context) => HomePage(index: 0),
                                              //   ),
                                              //   (_) => false,
                                              // );
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  elevation: 20,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surfaceVariant,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  clipBehavior: Clip.antiAlias,
                                                  dismissDirection:
                                                      DismissDirection
                                                          .horizontal,
                                                  margin: EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            180,
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                  content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 16, 0),
                                                        child: Icon(Icons
                                                            .file_download_done_rounded),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'カードを追加しました',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                              overflow:
                                                                  TextOverflow
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
                                              // Navigator.of(context).push(
                                              //   MaterialPageRoute(
                                              //     builder: (context) => HomePage(index: 1),
                                              //   ),
                                              // );
                                            },
                                            child: const Text('追加'),
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
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
