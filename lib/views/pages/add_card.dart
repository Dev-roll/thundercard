import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../utils/constants.dart';
import '../widgets/my_card.dart';
import 'home_page.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key, required this.applyingId, required this.cardId})
      : super(key: key);
  final String applyingId;
  // final applyingId;
  final String cardId;

  @override
  State<AddCard> createState() => _AddCardState();
}

void applyCard(String myCardId, String anotherCardId) async {
  // 1
  final DocumentReference myc10r10u10d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u10d10');
  myc10r10u10d10.set({
    'applying_cards': FieldValue.arrayUnion([anotherCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // 2
  final DocumentReference anotherc10r10u21d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u21d10');
  anotherc10r10u21d10.set({
    'verified_cards': FieldValue.arrayUnion([myCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // my room
  final DocumentReference myc21r20u00d11 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c21r20u00d11');
  final String myUid = await myc21r20u00d11.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['uid'];
  });

  final Room room =
      await FirebaseChatCore.instance.createRoom(User.fromJson({'id': myUid}));
  final DocumentReference myc10r21u21d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r21u21d10');
  myc10r21u21d10.set({
    'rooms': {anotherCardId: room.toJson()}
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // my notification
  final addApplyingNotificationData = {
    'title': 'カード交換リクエスト完了のお知らせ',
    'content':
        '@$anotherCardIdさんにカード交換をリクエストしました！\n@$anotherCardIdさんに承認されるまでお待ちください。',
    // 'title': 'カード送信完了のお知らせ',
    // 'content': '@$anotherCardIdさんにカードが送信されました！',
    'created_at': DateTime.now(),
    'read': false,
    'tags': ['interaction'],
    'notification_id': '',
  };
  FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u10d10')
      .collection('notifications')
      .add(addApplyingNotificationData);

  // another notification
  final addVerifiedNotificationData = {
    'title': 'カード交換リクエストのお知らせ',
    'content': '@$myCardIdさんからカード交換のリクエストが届きました！\n「承認」ボタンを押すとカード交換が完了します。',
    'created_at': DateTime.now(),
    'read': false,
    'tags': ['interaction', 'apply', 'important'],
    'notification_id': myCardId,
  };
  FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u10d10')
      .collection('notifications')
      .add(addVerifiedNotificationData);
}

void verifyCard(String anotherCardId, String myCardId) async {
  // 3
  final DocumentReference anotherc10r10u10d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u10d10');
  anotherc10r10u10d10.set({
    'applying_cards': FieldValue.arrayUnion([myCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // 4
  final DocumentReference myc10r10u21d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u21d10');
  myc10r10u21d10.set({
    'verified_cards': FieldValue.arrayUnion([anotherCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // 5
  final DocumentReference anotherc10r10u11d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u11d10');
  anotherc10r10u11d10.set({
    'exchanged_cards': FieldValue.arrayUnion([myCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // 6
  final DocumentReference myc10r10u11d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u11d10');
  myc10r10u11d10.set({
    'exchanged_cards': FieldValue.arrayUnion([anotherCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // another room
  final DocumentReference anotherc21r20u00d11 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c21r20u00d11');
  final String anotherUid =
      await anotherc21r20u00d11.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['uid'];
  });

  final Room room = await FirebaseChatCore.instance
      .createRoom(User.fromJson({'id': anotherUid}));
  final DocumentReference anotherc10r21u21d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r21u21d10');
  anotherc10r21u21d10.set({
    'rooms': {myCardId: room.toJson()}
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // another notification
  final addverifyingNotificationData = {
    'title': 'カード交換完了のお知らせ',
    'content': '@$myCardIdさんとのカード交換が完了しました！',
    'created_at': DateTime.now(),
    'read': false,
    'tags': ['interaction', 'done'],
    'notification_id': '',
  };
  FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u10d10')
      .collection('notifications')
      .add(addverifyingNotificationData);

  // my notification
  final addAppliedNotificationData = {
    'title': 'カード交換完了のお知らせ',
    'content': '@$anotherCardIdさんとのカード交換が完了しました！',
    'created_at': DateTime.now(),
    'read': false,
    'tags': ['interaction', 'done'],
    'notification_id': '',
  };
  FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u10d10')
      .collection('notifications')
      .add(addAppliedNotificationData);
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    final applyingId = widget.applyingId;
    final String addCardId = widget.cardId;

    return Scaffold(
      appBar: AppBar(title: const Text('カードを交換')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                  ),
                  child: FittedBox(
                    child: MyCard(
                      cardId: addCardId,
                      cardType: CardType.normal,
                      exchange: addCardId == applyingId ? false : true,
                    ),
                  ),
                ),
                if (addCardId == applyingId)
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'ユーザー自身のカードは交換できません',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
