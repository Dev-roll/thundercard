import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:intl/intl.dart';

import 'widgets/my_card.dart';
import 'constants.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key, required this.myCardId, required this.cardId})
      : super(key: key);
  final String myCardId;
  // final myCardId;
  final String cardId;

  @override
  State<AddCard> createState() => _AddCardState();
}

void handleExchange(String myCardId, anotherCardId) async {
  final DocumentReference anotherc11r20u00d11 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c11r20u00d11');

  final DocumentReference myc10r10u10d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u10d10');
  final DocumentReference anotherc10r10u21d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u21d10');
  final DocumentReference myc10r10u11d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u11d10');
  final DocumentReference myc10r21u21d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r21u21d10');

  // final DocumentReference anotherc10r10u10d10 = FirebaseFirestore.instance
  //     .collection('version')
  //     .doc('2')
  //     .collection('cards')
  //     .doc(anotherCardId)
  //     .collection('visibility')
  //     .doc('c10r10u10d10');
  // final DocumentReference myc10r10u21d10 = FirebaseFirestore.instance
  //     .collection('version')
  //     .doc('2')
  //     .collection('cards')
  //     .doc(myCardId)
  //     .collection('visibility')
  //     .doc('c10r10u21d10');
  final DocumentReference anotherc10r10u11d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u11d10');
  final DocumentReference anotherc10r21u21d10 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r21u21d10');

  final String anotherUid =
      await anotherc11r20u00d11.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['uid'];
  });
  final Room room = await FirebaseChatCore.instance
      .createRoom(User.fromJson({'id': anotherUid}));

  myc10r10u10d10.set({
    'applying_cards': FieldValue.arrayUnion([anotherCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });
  anotherc10r10u21d10.set({
    'verified_cards': FieldValue.arrayUnion([myCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });
  myc10r10u11d10.set({
    'exchanged_cards': FieldValue.arrayUnion([anotherCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });
  myc10r21u21d10.update({'rooms.$myCardId': room.toJson()}).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

  // myc10r10u10d10.set({
  //   'applying_cards': FieldValue.arrayUnion([anotherCardId]),
  // }, SetOptions(merge: true)).then((value) {
  //   debugPrint('DocumentSnapshot successfully updated');
  // }, onError: (e) {
  //   debugPrint('Error updating document $e');
  // });
  // anotherc10r10u21d10.set({
  //   'verified_cards': FieldValue.arrayUnion([myCardId]),
  // }, SetOptions(merge: true)).then((value) {
  //   debugPrint('DocumentSnapshot successfully updated');
  // }, onError: (e) {
  //   debugPrint('Error updating document $e');
  // });
  anotherc10r10u11d10.set({
    'exchanged_cards': FieldValue.arrayUnion([myCardId]),
  }, SetOptions(merge: true)).then((value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });
  anotherc10r21u21d10.update({'rooms.$anotherCardId': room.toJson()}).then(
      (value) {
    debugPrint('DocumentSnapshot successfully updated');
  }, onError: (e) {
    debugPrint('Error updating document $e');
  });

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
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(myCardId)
      .collection('visibility')
      .doc('c10r10u10d10')
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
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(anotherCardId)
      .collection('visibility')
      .doc('c10r10u10d10')
      .collection('notifications')
      .add(addAnotherNotificationData);
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    final myCardId = widget.myCardId;
    final String addCardId = widget.cardId;

    return Scaffold(
      appBar: AppBar(title: const Text('カードを交換')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 32),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                  ),
                  child: FittedBox(
                    child: MyCard(
                      cardId: addCardId,
                      cardType: CardType.normal,
                      exchange: addCardId == myCardId ? false : true,
                    ),
                  ),
                ),
                if (addCardId == myCardId)
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      const Text('ユーザー自身のカードは交換できません'),
                      const SizedBox(height: 24),
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
