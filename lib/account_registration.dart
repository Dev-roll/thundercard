import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'api/firebase_auth.dart';
import 'auth_gate.dart';

class AccountRegistration extends StatefulWidget {
  const AccountRegistration({Key? key}) : super(key: key);

  @override
  State<AccountRegistration> createState() => _AccountRegistrationState();
}

class _AccountRegistrationState extends State<AccountRegistration> {
  final String? uid = getUid();
  final TextEditingController _cardIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> registerCard() {
    users
        .doc(uid)
        .set({
          'my_cards': [_cardIdController.text]
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    final registerNotificationData = {
      'title': '登録完了のお知らせ',
      'content':
          '${_nameController.text}(@${_cardIdController.text})さんのアカウント登録が完了しました',
      'created_at': DateTime.now(),
      'read': false,
      'tags': ['news'],
    };

    FirebaseFirestore.instance
        .collection('cards')
        .doc(_cardIdController.text)
        .collection('notifications')
        .add(registerNotificationData);

    return cards.doc(_cardIdController.text).set({
      'name': _nameController.text,
      'bio': _bioController.text,
      'url': _urlController.text,
      'twitter': _twitterController.text,
      'github': _githubController.text,
      'company': _companyController.text,
      'email': _emailController.text,
      'is_user': true,
      'uid': uid,
      'exchanged_cards': [],
    }).then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
      print('Card Registered');
    }).catchError((error) => print('Failed to register card: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィールを登録'),
          actions: [
            TextButton(onPressed: registerCard, child: const Text('登録')),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('ユーザー名'),
                            TextField(
                              controller: _cardIdController,
                            ),
                            Text('名前'),
                            TextField(
                              controller: _nameController,
                            ),
                            Text('自己紹介'),
                            TextField(
                              controller: _bioController,
                            ),
                            const Text('URL'),
                            TextField(
                              controller: _urlController,
                            ),
                            const Text('Twitter'),
                            TextField(
                              controller: _twitterController,
                            ),
                            const Text('GitHub'),
                            TextField(
                              controller: _githubController,
                            ),
                            const Text('所属'),
                            TextField(
                              controller: _companyController,
                            ),
                            const Text('メールアドレス'),
                            TextField(
                              controller: _emailController,
                            ),
                          ],
                        ))))),
      ),
    );
  }
}
