// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart';
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// import 'package:intl/intl.dart';

// import 'widgets/my_card.dart';
// import 'constants.dart';

// class AddCard extends StatefulWidget {
//   const AddCard({Key? key, required this.myCardId, required this.cardId})
//       : super(key: key);
//   final myCardId;
//   final String cardId;

//   @override
//   State<AddCard> createState() => _AddCardState();
// }

// void handleExchange(String myCardId, anotherCardId) async {
//   final DocumentReference myCard =
//       FirebaseFirestore.instance.collection('cards').doc(myCardId);
//   final DocumentReference anotherCard =
//       FirebaseFirestore.instance.collection('cards').doc(anotherCardId);
//   final String anotherUid =
//       await anotherCard.get().then((DocumentSnapshot res) {
//     final data = res.data() as Map<String, dynamic>;
//     return data['uid'];
//   });
//   final Room room = await FirebaseChatCore.instance
//       .createRoom(User.fromJson({'id': anotherUid}));

//   myCard.update({
//     'exchanged_cards': FieldValue.arrayUnion([anotherCardId]),
//     'rooms.$anotherCardId': room.toJson()
//   }).then((value) => print("DocumentSnapshot successfully updated"),
//       onError: (e) => print("Error updating document $e"));
//   anotherCard.update({
//     'exchanged_cards': FieldValue.arrayUnion([myCardId]),
//     'rooms.$myCardId': room.toJson()
//   }).then((value) => print("DocumentSnapshot successfully updated"),
//       onError: (e) => print("Error updating document $e"));

//   final addMyNotificationData = {
//     'title': 'カードリスト追加のお知らせ',
//     'content': '@$myCardIdさんのカードリストに@$anotherCardIdさんが追加されました！',
//     'created_at': DateTime.now(),
//     'read': false,
//     'tags': ['interaction'],
//     'notification_id':
//         'list-add-$myCardId-${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}',
//   };

//   FirebaseFirestore.instance
//       .collection('cards')
//       .doc(myCardId)
//       .collection('notifications')
//       .add(addMyNotificationData);

//   final addAnotherNotificationData = {
//     'title': 'カードリスト追加のお知らせ',
//     'content': '@$anotherCardIdさんのカードリストに@$myCardIdさんが追加されました！',
//     'created_at': DateTime.now(),
//     'read': false,
//     'tags': ['interaction'],
//     'notification_id':
//         'list-add-$anotherCardId-${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}',
//   };

//   FirebaseFirestore.instance
//       .collection('cards')
//       .doc(anotherCardId)
//       .collection('notifications')
//       .add(addAnotherNotificationData);
// }

// class _AddCardState extends State<AddCard> {
//   @override
//   Widget build(BuildContext context) {
//     final myCardId = widget.myCardId;
//     final String addCardId = widget.cardId;

//     return Scaffold(
//       appBar: AppBar(title: const Text('カードを交換')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               children: [
//                 const SizedBox(height: 32),
//                 MyCard(
//                   cardId: addCardId,
//                   cardType: CardType.normal,
//                   exchange: addCardId == myCardId ? false : true,
//                 ),
//                 if (addCardId == myCardId)
//                   Column(
//                     children: [
//                       const SizedBox(height: 32),
//                       const Text('ユーザー自身のカードは交換できません'),
//                       const SizedBox(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           OutlinedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text('OK'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
