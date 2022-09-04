import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String _inputVal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter × Firestore'),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc('${widget.uid}')
                        .collection('cards')
                        .doc('example')
                        .snapshots(),
                    builder: (context, snapshot) {
                      // 取得が完了していないときに表示するWidget
                      // if (snapshot.connectionState != ConnectionState.done) {
                      //   // インジケーターを回しておきます
                      //   return const CircularProgressIndicator();
                      // }

                      // エラー時に表示するWidget
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('エラー');
                      }

                      // データが取得できなかったときに表示するWidget
                      if (!snapshot.hasData) {
                        return Text('データがない');
                      }

                      dynamic hoge = snapshot.data;
                      // 取得したデータを表示するWidget
                      return Column(
                        children: [
                          Text('ユーザーネーム: ${hoge?['username']}'),
                          Text('自己紹介: ${hoge?['bio']}'),
                          Text('SNS: ${hoge?['social']}'),
                          Image.network(hoge?['thumbnail']),
                        ],
                      );
                    },
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _inputVal = value;
                      });
                    },
                    // obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your Name',
                      hintText: 'Enter your name',
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc('${widget.uid}')
                            .collection('cards')
                            .doc('example')
                            .update({'bio': _inputVal});
                      },
                      child: const Text('Renew')),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
