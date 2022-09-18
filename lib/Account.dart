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
  final cardId = 'keigomichi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('cards')
                        .doc(cardId)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      dynamic data = snapshot.data;
                      return Column(
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AccountEditor(data: data, cardId: cardId),
                                ));
                              },
                              child: const Text('プロフィールを編集')),
                          Text('username: ${data?['name']}'),
                          Text('bio: ${data?['bio']}'),
                          Text('URL: ${data?['url']}'),
                          Text('Twitter: ${data?['twitter']}'),
                          Text('GitHub: ${data?['github']}'),
                          Text('company: ${data?['company']}'),
                          Text('email: ${data?['email']}'),
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
      ),
    );
  }
}
