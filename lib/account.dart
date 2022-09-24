import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thundercard/auth_gate.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'account_editor.dart';
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
    CollectionReference cards = FirebaseFirestore.instance.collection('cards');

    return Scaffold(
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
                        child: StreamBuilder<DocumentSnapshot<Object?>>(
                          stream: cards.doc(user['my_cards'][0]).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            dynamic data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${data?['name']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => AccountEditor(
                                                data: data,
                                                cardId: user['my_cards'][0]),
                                          ));
                                        },
                                        child: const Icon(Icons.edit_rounded)),
                                  ],
                                ),
                                data?['bio'] != ''
                                    ? Text(
                                        'bio: ${data?['bio']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    : Container(),
                                data?['url'] != ''
                                    ? Text(
                                        'URL: ${data?['url']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    : Container(),
                                data?['twitter'] != ''
                                    ? Text(
                                        'Twitter: ${data?['twitter']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    : Container(),
                                data?['github'] != ''
                                    ? Text(
                                        'GitHub: ${data?['github']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    : Container(),
                                data?['company'] != ''
                                    ? Text(
                                        'company: ${data?['company']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    : Container(),
                                data?['email'] != ''
                                    ? Text(
                                        'email: ${data?['email']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        ),
                      ),
                    )),
                  );
                }
                return const Center(child: CustomProgressIndicator());
              }),
          ElevatedButton(
              // onPressed: () => FirebaseAuth.instance.signOut(),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AuthGate(),
                  ),
                  (_) => false,
                );
              },
              child: const Text('Sign out')),
        ],
      ),
    );
  }
}
