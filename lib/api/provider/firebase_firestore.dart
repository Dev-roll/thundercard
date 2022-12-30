import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase_auth.dart';

final uid = getUid();

getCardId() {
  FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('card')
      .doc('current_card')
      .get()
      .then((value) {
    return value['current_card'];
  });
}

Future<bool> getIsUser(String cardId) async {
  DocumentReference card = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c21r20u00d11');
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
  DocumentReference card = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c10r20u10d10');
  final String displayName = await card.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['name'];
  }).catchError((error) {
    debugPrint('Failed to add user: $error');
    return 'Cannot get name';
  });
  return displayName;
}

final currentCardStream = StreamProvider.autoDispose<dynamic>((ref) {
  final prefs = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('card')
      .doc('current_card')
      .snapshots();
  return prefs;
});

final c10r10u11d10Stream =
    StreamProvider.autoDispose.family<dynamic, String>((ref, cardId) {
  final prefs = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c10r10u11d10')
      .snapshots();
  return prefs;
});

final c10r20u10d10Stream =
    StreamProvider.autoDispose.family<dynamic, String>((ref, cardId) {
  final prefs = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c10r20u10d10')
      .snapshots();
  return prefs;
});

final c10r21u10d10Stream =
    StreamProvider.autoDispose.family<dynamic, String>((ref, cardId) {
  final prefs = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c10r21u10d10')
      .snapshots();
  return prefs;
});

final c10r21u10d10Future =
    FutureProvider.autoDispose.family<dynamic, String>((ref, cardId) async {
  final prefs = await FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c10r21u10d10')
      .get();
  return prefs.data();
});

final c21r20u00d11Stream =
    StreamProvider.autoDispose.family<dynamic, String>((ref, cardId) {
  final prefs = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c21r20u00d11')
      .snapshots();
  return prefs;
});

final c20r11u11d11Stream =
    StreamProvider.autoDispose.family<dynamic, String>((ref, cardId) {
  final prefs = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards')
      .doc(cardId)
      .collection('visibility')
      .doc('c20r11u11d11')
      .snapshots();
  return prefs;
});
