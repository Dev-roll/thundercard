import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_auth.dart';

getCardId() {
  FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('card')
      .doc('current_card')
      .get()
      .then((value) {
    return value['current_card'];
  });
}

Future<bool> getIsUser(String cardId) async {
  DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(cardId);
  final bool isUser = await card.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['is_user'];
  }).catchError((error) {
    debugPrint('Failed to add user: $error');
    return false;
  });
  return isUser;
}

Future<String> getDisplayName(String cardId) async {
  DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(cardId);
  final String displayName = await card.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['account']['profiles']['name'];
  }).catchError((error) {
    debugPrint('Failed to add user: $error');
    return 'Cannot get name';
  });
  return displayName;
}

Future<DocumentSnapshot> getCard(String cardId) async {
  DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(cardId);
  final DocumentSnapshot res = await card.get().catchError((error) {
    debugPrint('Failed to add user: $error');
  });
  return res;
}
