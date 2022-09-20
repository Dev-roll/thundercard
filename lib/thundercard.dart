import 'package:flutter/material.dart';
import 'package:thundercard/widgets/scan_qr_code.dart';
import 'api/firebase_auth.dart';
import 'widgets/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Thundercard extends StatefulWidget {
  const Thundercard({Key? key}) : super(key: key);

  @override
  State<Thundercard> createState() => _ThundercardState();
}

class _ThundercardState extends State<Thundercard> {
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder(
                        future: users.doc(uid).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return const Text('Document does not exist');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> user =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return MyCard(cardId: user['my_cards'][0]);
                          }
                          return const Text('loading');
                        },
                      ),
                    ),
                    Text('uid: $uid'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const QRViewExample(),
          ));
        },
        icon: const Icon(
          Icons.qr_code_scanner_rounded,
          size: 24,
        ),
        label: const Text('名刺交換'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
