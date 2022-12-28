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
      .doc(cardId);
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

// final StreamProvider c10r21u10d10Provider =
//     StreamProvider<dynamic>((ref) async {
//   final prefs = await FirebaseFirestore.instance
//       .collection('version')
//       .doc('2')
//       .collection('cards')
//       .collection('visibility')
//       .doc('c10r21u10d10')
//       .get();
//   return prefs.data();
// });

final currentCardStream = StreamProvider<dynamic>((ref) {
  final prefs = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('card')
      .doc('current_card')
      .snapshots();
  return prefs;
});

final c10r10u11d10Stream =
    StreamProvider.family<dynamic, String>((ref, cardId) {
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
    StreamProvider.family<dynamic, String>((ref, cardId) {
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
    StreamProvider.family<dynamic, String>((ref, cardId) {
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
    FutureProvider.family<dynamic, String>((ref, cardId) async {
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
    StreamProvider.family<dynamic, String>((ref, cardId) {
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
    StreamProvider.family<dynamic, String>((ref, cardId) {
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

// StreamProvider getc10r21u10d10(String cardId) {
//   final StreamProvider c10r21u10d10Provider = StreamProvider<dynamic>((ref) {
//     final prefs = FirebaseFirestore.instance
//         .collection('version')
//         .doc('2')
//         .collection('cards')
// //         .doc(cardId)
//         .collection('visibility')
//         .doc('c10r21u10d10')
//         .get()
//         .then((value) {
//       return value.data();
//     });
//     // return prefs?.data();
//   });
//   return c10r21u10d10Provider;
// }
