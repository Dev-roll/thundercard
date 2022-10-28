import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:thundercard/api/firebase_firestore.dart';

import '../../constants.dart';
import 'firebase_auth.dart';

class MyCardId extends ChangeNotifier {
  // int fetchData() {
  //   FirebaseFirestore.instance
  //       .collection('cards')
  //       .doc('getCardId()')
  //       .get()
  //       .then((snapshot) {
  //     final card = snapshot.data();
  //     print('■■■■■■■■■■■■■■■■■■■■■■■■${card?['settings']?['app_theme']}');
  //   });
  //   return 2;
  // }

  // Future<String> getCardId() async {
  //   final String? uid = getUid();
  //   print(uid);
  //   final DocumentReference user =
  //       FirebaseFirestore.instance.collection('users').doc(uid);
  //   final String myCardId = await user.get().then((DocumentSnapshot res) {
  //     final data = res.data() as Map<String, dynamic>;
  //     return data['my_cards'][0];
  //   });
  //   return myCardId;
  // }

  String myCardId = ' ';

  void recordId(String id) {
    myCardId = id;
    notifyListeners();
  }
}
