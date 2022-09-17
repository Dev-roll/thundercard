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
                        return Text('error');
                      }

                      // データが取得できなかったときに表示するWidget
                      if (!snapshot.hasData) {
                        return Text('no data');
                      }

                      dynamic hoge = snapshot.data;
                      // 取得したデータを表示するWidget
                      return Column(
                        children: [
                          Text('username: ${hoge?['name']}'),
                          Text('bio: ${hoge?['bio']}'),
                          Text('URL: ${hoge?['url']}'),
                          Text('Twitter: ${hoge?['twitter']}'),
                          Text('GitHub: ${hoge?['github']}'),
                          Text('company: ${hoge?['company']}'),
                          Text('email: ${hoge?['email']}'),
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
                      labelText: 'bio',
                      hintText: 'enter new bio',
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('cards')
                            .doc('example')
                            .update({'bio': _inputVal});
                      },
                      child: const Text('renew')),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
