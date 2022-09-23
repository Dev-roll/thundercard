import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'package:thundercard/widgets/card_info.dart';
import 'api/firebase_auth.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final String? uid = getUid();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
      ),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
              future: users.doc(uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> user =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return SafeArea(
                    child: SingleChildScrollView(
                        child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CardInfo(
                            cardId: user['my_cards'][0], editable: true),
                      ),
                    )),
                  );
                }
                return const Center(child: CustomProgressIndicator());
              }),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Sign out')),
        ],
      ),
    );
  }
}
