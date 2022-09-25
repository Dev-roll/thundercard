import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/card_details.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'package:thundercard/upload_image_page.dart';
import 'package:thundercard/widgets/chat/room_list_page.dart';
import 'package:thundercard/widgets/my_card.dart';
import 'api/firebase_auth.dart';

class List extends StatefulWidget {
  const List({
    Key? key,
  }) : super(key: key);

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');
  Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> user =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(children: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RoomListPage(),
                            ));
                          },
                          child: const Text('Chat'),
                        ),
                        StreamBuilder<DocumentSnapshot<Object?>>(
                          stream: cards.doc(user['my_cards'][0]).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CustomProgressIndicator();
                            }
                            dynamic data = snapshot.data;
                            final exchangedCards = data?['exchanged_cards'];

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: exchangedCards.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder<DocumentSnapshot<Object?>>(
                                  stream: cards
                                      .doc(exchangedCards[index])
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CustomProgressIndicator();
                                    }
                                    dynamic card = snapshot.data;
                                    if (!snapshot.hasData) {
                                      return Text('no data');
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => CardDetails(
                                              cardId: exchangedCards[index]),
                                        ));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                          ),
                                          card?['is_user'] == true
                                              ? MyCard(
                                                  cardId: exchangedCards[index])
                                              : card?['thumbnail'] != null
                                                  ? Image.network(
                                                      card?['thumbnail'])
                                                  : const CustomProgressIndicator(),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadImagePage(
                            cardId: user['my_cards'][0],
                          ),
                      fullscreenDialog: true));
                },
                icon: const Icon(
                  Icons.add_a_photo_rounded,
                  size: 24,
                ),
                label: const Text('紙の名刺を追加'),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CustomProgressIndicator()),
          );
        });
  }
}
