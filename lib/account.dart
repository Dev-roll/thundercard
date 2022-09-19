import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_editor.dart';
import 'api/firebase_auth.dart';

class Account extends StatefulWidget {
  const Account({
    Key? key,
    required this.uid,
  }) : super(key: key);
  final String? uid;
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
      appBar: AppBar(
        title: const Text('アカウント'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                child: Scrollbar(
                  child: SingleChildScrollView(
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<DocumentSnapshot<Object?>>(
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
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => AccountEditor(
                                              data: data,
                                              cardId: user['my_cards'][0]),
                                        ));
                                      },
                                      child: const Text('プロフィールを編集')),
                                  Text('username: ${data?['name']}'),
                                  data?['bio'] != ''
                                      ? Text('bio: ${data?['bio']}')
                                      : Container(),
                                  data?['url'] != ''
                                      ? Text('URL: ${data?['url']}')
                                      : Container(),
                                  data?['twitter'] != ''
                                      ? Text('Twitter: ${data?['twitter']}')
                                      : Container(),
                                  data?['github'] != ''
                                      ? Text('GitHub: ${data?['github']}')
                                      : Container(),
                                  data?['company'] != ''
                                      ? Text('company: ${data?['company']}')
                                      : Container(),
                                  data?['email'] != ''
                                      ? Text('email: ${data?['email']}')
                                      : Container(),
                                  Image.network(data?['thumbnail']),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
              );
            }
            return Text("loading");
          }),
    );
  }
}
