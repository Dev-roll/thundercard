import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // 階層構造の参考用
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc('${FirebaseAuth.instance.currentUser?.uid}')
  //           .collection('cards') // コレクション
  //           .doc('example')
  //           .get()

  var bio = '';
  hoge () async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser?.uid}')
        .collection('cards')
        .doc('example')
        .get()
        .then((ref) {
      // dynamicならいけた
      dynamic data = ref.data();

      // これだと無限ループ
      // setState(() {
      //   bio = data['bio'];
      // });

      print('important: ${bio}');
      // return bio;
    });
  }

  // 良さそうなので残しとく
  // hoge () async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('${FirebaseAuth.instance.currentUser?.uid}')
  //       .collection('cards') // コレクション
  //       .doc('example')
  //       .get()
  //       .then((ref) {
  //     Map _returnVal = ref.get("social");
  //     var _returnVal2 = _returnVal["twitter"];
  //     print('important: ${_returnVal2}');
  //     return _returnVal2;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('${hoge()}'),
      ),
    );
  }
}

// class Account extends StatefulWidget {
//   const Account({Key? key}) : super(key: key);
//   @override
//   _AccountState createState() => _AccountState();
// }

// class _AccountState extends State<Account> {
//   String _inputVal = '';
//   String _returnVal = '';
//   var data = {
//     'username': '',
//     'bio': '',
//     // 'social': {
//     'url': '',
//     'twitter': '',
//     'github': '',
//     'company': '',
//     'email': '',
//     // },
//     'thumbnail': '',
//   };

//   void connectData() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc('${FirebaseAuth.instance.currentUser?.uid}')
//           .collection('cards') // コレクション
//           .doc('example')
//           .get()
//           .then(
//         (ref) {
//           data['username'] = ref.get('username');
//           data['bio'] = ref.get('bio');
//           data['url'] = ref.get('url');
//           data['twitter'] = ref.get('twitter');
//           data['github'] = ref.get('github');
//           data['company'] = ref.get('company');
//           data['email'] = ref.get('email');
//           data['thumbnail'] = ref.get('thumbnail');
//           print(data);
//         },
//         onError: (e) => print("Error getting user information: $e"),
//       );
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Scrollbar(
//           child: SingleChildScrollView(
//               child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                     onChanged: (value) {
//                       setState(() {
//                         _inputVal = value;
//                       });
//                     },
//                     // obscureText: true,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Your Name',
//                       hintText: 'Enter your name',
//                     ),
//                   ),
//                   OutlinedButton(
//                       onPressed: () {
//                         connectData();
//                         setState(() {});
//                       },
//                       child: const Text('Renew')),
//                   Text('username: ${data['username']}'),
//                   Text('bio: ${data['bio']}'),
//                   Text('url: ${data['url']}'),
//                   Text('twitter: ${data['twitter']}'),
//                   Text('github: ${data['github']}'),
//                   Text('company: ${data['company']}'),
//                   Text('email: ${data['email']}'),
//                   Text('thumbnail: ${data['thumbnail']}'),
//                   Image.network("${data['thumbnail']}")
//                 ],
//               ),
//             ),
//           )),
//         ),
//       ),
//     );
//   }
// }
