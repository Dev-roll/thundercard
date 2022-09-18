import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountEditor extends StatefulWidget {
  const AccountEditor({Key? key, required this.data, required this.cardId})
      : super(key: key);
  final dynamic data;
  final dynamic cardId;

  @override
  State<AccountEditor> createState() => _AccountEditorState();
}

class _AccountEditorState extends State<AccountEditor> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late final TextEditingController _nameController =
      TextEditingController(text: widget.data?['name']);
  late final TextEditingController _bioController =
      TextEditingController(text: widget.data?['bio']);
  late final TextEditingController _urlController =
      TextEditingController(text: widget.data?['url']);
  late final TextEditingController _twitterController =
      TextEditingController(text: widget.data?['twitter']);
  late final TextEditingController _githubController =
      TextEditingController(text: widget.data?['github']);
  late final TextEditingController _companyController =
      TextEditingController(text: widget.data?['company']);
  late final TextEditingController _emailController =
      TextEditingController(text: widget.data?['email']);
  // late final TextEditingController _thumbnailController =
  //     TextEditingController(text: widget.data?['thumbnail']);

  late DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(widget.cardId);

  Future<void> updateCard() {
    return card.update({
      'name': _nameController.text,
      'bio': _bioController.text,
      'url': _urlController.text,
      'twitter': _twitterController.text,
      'github': _githubController.text,
      'company': _companyController.text,
      'email': _emailController.text
    }).then((value) {
      Navigator.of(context).pop();
      print('Card Updated');
    }).catchError((error) => print('Failed to update card: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィールを編集'),
        actions: [
          TextButton(onPressed: updateCard, child: Text('保存')),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc('${uid}')
                                .collection('cards')
                                .doc('example')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                return Text('Error');
                              }
                              if (!snapshot.hasData) {
                                return Text('No data');
                              }
                              dynamic data = snapshot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text('ユーザー名'),
                                  TextField(
                                    controller: _nameController,
                                  ),
                                  const Text('自己紹介'),
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
                                  const Text('自分の名刺'),
                                  // Image.network(data?['thumbnail']),
                                ],
                              );
                            },
                          ),
                        ],
                      ))))),
    );
  }
}
