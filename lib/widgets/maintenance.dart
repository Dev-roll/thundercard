// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';

// maintenance() {
//   // const currentCardId = 'user';
//   // const currentDocId = null;

//   const cardIds = [
//     'cardseditor',
//     // 'example',
//     // 'fuga',
//     // 'keigomichi',
//     // 'user'

//     // 'eymupktcco'
//     // 'raSZmUODKP1h6LfSIvVq'
//   ];

//   cardIds.forEach((currentCardId) {
//     // data

//     // 通知用map
//     // final notification = {
//     //   'title': 'テスト2',
//     //   'content': '2番目のテスト用通知です。',
//     //   'created_at': DateTime.now(),
//     //   'read': false,
//     //   'tags': ['news'],
//     //   'notification_id': '220926news03-test'
//     // };

//     // 特定位置の更新用
//     // final profiles = {
//     //   'account.profiles': {
//     //     'name': 'CE',
//     //     // 'bio.value': 'Hi',
//     //   }
//     // };

//     // 単純なデータ
//     // final public = {'public': false};

//     // アカウント情報
//     // final account = {
//     //   'account': {
//     //     'profiles': {
//     //       'name': '',
//     //       'bio': {
//     //         'value': '',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //       'company': {
//     //         'value': '',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //       'position': {
//     //         'value': '',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //       'address': {
//     //         'value': '',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //     },
//     //     'links': [
//     //       {
//     //         'key': 'email',
//     //         'value': 'example@example.com',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //       {
//     //         'key': 'github',
//     //         'value': 'example',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //       {
//     //         'key': 'twitter',
//     //         'value': 'example',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //       {
//     //         'key': 'url',
//     //         'value': 'https://github.com/',
//     //         'display': {'extended': true, 'normal': true},
//     //       },
//     //     ],
//     //   }
//     // };

//     // アカウント情報
//     // final account = {
//     //     'is_user': false,
//     //     'name': '',
//     //     'thumbnail': '',
//     //     'account': {
//     //       'profiles': {
//     //         'name': '',
//     //         'bio': {
//     //           'value': '',
//     //           'display': {'extended': true, 'normal': true},
//     //         },
//     //         'company': {
//     //           'value': '',
//     //           'display': {'extended': true, 'normal': true},
//     //         },
//     //         'position': {
//     //           'value': '',
//     //           'display': {'extended': true, 'normal': true},
//     //         },
//     //         'address': {
//     //           'value': '',
//     //           'display': {'extended': true, 'normal': true},
//     //         },
//     //       },
//     //       'links': [],
//     //     },
//     //   };

//     // function

//     // 通知情報の一覧を取得
//     // FirebaseFirestore.instance
//     //     .collection('cards')
//     //     .doc(currentCardId)
//     //     .collection('notifications')
//     //     .where('tags', arrayContains: 'interaction')
//     //     .where('title', isEqualTo: 'テスト')
//     //     .get()
//     //     .then((QuerySnapshot querySnapshot) => (querySnapshot.docs.forEach((element) {debugPrint(element['created_at']);})));

//     // update
//     // FirebaseFirestore.instance
//     //     .collection('cards')
//     //     .doc(currentCardId)
//     //     .update(account)
//     //     .then((element) {
//     //   debugPrint('completed');
//     // });

//     // set
//     // FirebaseFirestore.instance
//     //     .collection('cards')
//     //     .doc(currentCardId)
//     //     .set(account)
//     //     .then((element) {
//     //   debugPrint('completed');
//     // });

//     // add
//     // FirebaseFirestore.instance
//     //     .collection('cards')
//     //     .doc(currentCardId)
//     //     .collection('notifications')
//     //     // .doc(currentDocId)
//     //     .add(notification)
//     //     .then((element) {
//     //   debugPrint('completed');
//     // });

//     // queryを使って削除
//     // num seconds;
//     // num nanoseconds;

//     // FirebaseFirestore.instance
//     //     .collection('cards')
//     //     .doc(currentCardId)
//     //     .collection('notifications')
//     //     .where('created_at',
//     //         isGreaterThan:
//     //             Timestamp(seconds = 1664097265, nanoseconds = 000000000))
//     //     .where('created_at',
//     //         isLessThan:
//     //             Timestamp(seconds = 1664097267, nanoseconds = 000000000))
//     //     .get()
//     //     .then((snapshot) {
//     //   snapshot.docs.forEach((element) {
//     //     debugPrint('$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']}');
//     //     element.reference.delete();
//     //   });
//     // });

//     // idを使って更新
//     // const notificationId = '220926news01-test';

//     // FirebaseFirestore.instance
//     //     .collection('cards')
//     //     .doc(currentCardId)
//     //     .collection('notifications')
//     //     .where('notification_id', isEqualTo: notificationId)
//     //     .get()
//     //     .then((snapshot) {
//     //   snapshot.docs.forEach((element) {
//     //     debugPrint(
//     //         '$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']} / ${element['notification_id']}');
//     //     element.reference.update({
//     //       'title': '【更新】アカウント情報の追加・更新について',
//     //       'content':
//     //           '更新　\nデータ構造を変更した影響により、現時点では新規のアカウント登録及びアカウント情報の更新の機能を修正できておりません。これらの操作はFirebase管理画面から手動で行ってください。',
//     //       'created_at': DateTime.now(),
//     //       'read': false,
//     //       'tags': ['news'],
//     //       'notification_id': '220926news01-test'
//     //     });
//     //     // element.reference.delete();
//     //   });
//     // });

//     // idを使って削除
//     // const notificationId = '220926news01-test';

//     // FirebaseFirestore.instance
//     //     .collection('cards')
//     //     .doc(currentCardId)
//     //     .collection('notifications')
//     //     .where('notification_id', isEqualTo: notificationId)
//     //     .get()
//     //     .then((snapshot) {
//     //   snapshot.docs.forEach((element) {
//     //     debugPrint(
//     //         '$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']} / ${element['notification_id']}');
//     //     element.reference.delete();
//     //     // element.reference.delete();
//     //   });
//     // });

//     //
//   });
// }
