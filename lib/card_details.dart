import 'package:flutter/material.dart';
import 'package:thundercard/api/firebase_firestore.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'package:thundercard/home_page.dart';
import 'package:thundercard/widgets/card_info.dart';
import 'package:thundercard/widgets/scan_qr_code.dart';
import 'api/firebase_auth.dart';
import 'widgets/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({Key? key, required this.cardId}) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context) {
    final String? uid = getUid();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var _usStates = [
      "edit information",
      "delete this card",
    ];

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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyCard(cardId: cardId),
                  ),
                  CardInfo(cardId: cardId, display: 'profile', editable: false)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
