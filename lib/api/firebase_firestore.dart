import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_auth.dart';

String? getCardId() {
  FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .get()
      .then((value) {
    return value['my_cards'][0];
  }).catchError((error) => print("Failed to add user: $error"));
}
