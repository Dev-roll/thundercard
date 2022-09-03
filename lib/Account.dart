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
  Future<Map<String, dynamic>> getDocumentData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('${widget.uid}')
        .collection('cards')
        .doc('example')
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    // final example = FirebaseFirestore.instance
    // .collection('users')
    // .doc('${widget.uid}')
    // .collection('cards')
    // .doc('example');

    return Scaffold(
      // stream: example.snapshots(),
      // builder: (context, snapshot) {
      //   return Text(snapshot.data['title'] as String);
      // },
      appBar: AppBar(
        title: Text('Flutter × Firestore'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getDocumentData(),
            builder: (context, snapshot) {
              // 取得が完了していないときに表示するWidget
              if (snapshot.connectionState != ConnectionState.done) {
                // インジケーターを回しておきます
                return const CircularProgressIndicator();
              }

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
              return Text(hoge['bio']);
            },
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Scrollbar(
  //         child: SingleChildScrollView(
  //             child: Center(
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               children: <Widget>[
  //                 TextField(
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _inputVal = value;
  //                     });
  //                   },
  //                   // obscureText: true,
  //                   decoration: const InputDecoration(
  //                     border: OutlineInputBorder(),
  //                     labelText: 'Your Name',
  //                     hintText: 'Enter your name',
  //                   ),
  //                 ),
  //                 OutlinedButton(
  //                     onPressed: () {
  //                       connectData();
  //                       setState(() {});
  //                     },
  //                     child: const Text('Renew')),
  //                 Text('username: ${data['username']}'),
  //                 Text('bio: ${data['bio']}'),
  //                 Text('url: ${data['url']}'),
  //                 Text('twitter: ${data['twitter']}'),
  //                 Text('github: ${data['github']}'),
  //                 Text('company: ${data['company']}'),
  //                 Text('email: ${data['email']}'),
  //                 Text('thumbnail: ${data['thumbnail']}'),
  //                 Image.network("${data['thumbnail']}")
  //               ],
  //             ),
  //           ),
  //         )),
  //       ),
  //     ),
  //   );
  // }
}
