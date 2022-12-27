// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final nameController =
//     StreamProvider.family<TextEditingController, String>((ref, cardId) {
//   final prefs = FirebaseFirestore.instance
//       .collection('version')
//       .doc('2')
//       .collection('cards')
//       .doc(cardId)
//       .collection('visibility')
//       .doc('c10r20u10d10')
//       .snapshots();
//   final hogehgoe = TextEditingController(text: prefs['name']);
//   return hogehoge;
// });
