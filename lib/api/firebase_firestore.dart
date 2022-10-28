import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_auth.dart';

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

Future<String> getDisplayName(String cardId) async {
  DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(cardId);
  final String displayName = await card.get().then((DocumentSnapshot res) {
    final data = res.data() as Map<String, dynamic>;
    return data['account']['profiles']['name'];
  }).catchError((error) {
    print("Failed to add user: $error");
    return 'Cannot get name';
  });
  return displayName;
}

Future<DocumentSnapshot> getCard(String cardId) async {
  DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(cardId);
  final DocumentSnapshot res = await card.get().catchError((error) {
    print("Failed to add user: $error");
  });
  return res;
}
