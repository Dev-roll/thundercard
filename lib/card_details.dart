import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:thundercard/chat.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'package:thundercard/home_page.dart';
import 'package:thundercard/widgets/card_info.dart';
import 'api/firebase_auth.dart';
import 'widgets/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  card['is_user']
                      ? Container()
                      : card?['thumbnail'] != null
                          ? Image.network(card?['thumbnail'])
                          : const CustomProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyCard(
                      cardId: cardId,
                      cardType: CardType.extended,
                    ),
                  ),
                  card['is_user']
                      ? Container()
                      : CardInfo(cardId: cardId, editable: false),
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
