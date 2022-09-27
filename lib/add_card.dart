import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'package:thundercard/home_page.dart';
import 'package:thundercard/widgets/my_card.dart';

import 'api/firebase_auth.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key, required this.cardId}) : super(key: key);
  final String cardId;

  @override
  State<AddCard> createState() => _AddCardState();
}

void updateExchangedCards1(myCardId, addCardId) {
  final DocumentReference myCard =
      FirebaseFirestore.instance.collection('cards').doc(myCardId);
  myCard.update({
    'exchanged_cards': FieldValue.arrayUnion([addCardId])
  }).then((value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
  final 
}

void updateExchangedCards2(myCardId, addCardId) {
  final doc = FirebaseFirestore.instance.collection('cards').doc(addCardId);
  doc.update({
    'exchanged_cards': FieldValue.arrayUnion([myCardId])
  }).then((value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    final String addCardId = widget.cardId.split('=').last;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final String? uid = getUid();

    return Scaffold(
      appBar: AppBar(title: Text('名刺を追加')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                MyCard(cardId: addCardId, cardType: CardType.normal,),
                Text('この名刺を追加しますか？'),
                Row(
                  children: [
                    FutureBuilder(
                      future: users.doc(uid).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Text('Document does not exist');
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> user =
                              snapshot.data!.data() as Map<String, dynamic>;
                          String myCardId = user['my_cards'][0];
                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('キャンセル'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  updateExchangedCards1(myCardId, addCardId);
                                  updateExchangedCards2(myCardId, addCardId);
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => HomePage(index: 1),
                                  //   ),
                                  // );
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(index: 1),
                                    ),
                                    (_) => false,
                                  );
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => HomePage(index: 1),
                                  //   ),
                                  // );
                                },
                                child: const Text('追加'),
                              ),
                            ],
                          );
                        }
                        return const CustomProgressIndicator();
                      },
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
