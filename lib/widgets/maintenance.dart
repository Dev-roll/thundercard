import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

maintenance() {
  // const currentCardId = 'user';
  // const currentDocId = null;

  const cardIds = [
    'cardseditor',
    // '2209211828',
    // 'example',
    // 'fuga',
    // 'keigomichi',
    // 'user'
  ];

  cardIds.forEach((currentCardId) {
    // data

    //通知用map
    // final notification = {
    //   'title': '【重要】アカウント情報の追加・更新について',
    //   'content': 'データ構造を変更した影響により、現時点では新規のアカウント登録及びアカウント情報の更新の機能を修正できておりません。これらの操作はFirebase管理画面から手動で行ってください。',
    //   'created_at': DateTime.now(),
    //   'read': false,
    //   'tags': ['news'],
    //   'message_id': '220926news01'
    // };

    // 単純なデータ
    // final public = {'public': false};

    // アカウント情報
    // final account = {
    //   'display': {'all': true, 'card': true, 'profile': true},
    //   'key': 'name',
    //   'value': currentCardId,
    //   'tag': 'profile'
    // };

    // function

    // 通知情報の一覧を取得
    // FirebaseFirestore.instance
    //     .collection('cards')
    //     .doc(currentCardId)
    //     .collection('notifications')
    //     .where('tags', arrayContains: 'interaction')
    //     .where('title', isEqualTo: 'テスト')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) => (querySnapshot.docs.forEach((element) {print(element['created_at']);})));

    // update
    // FirebaseFirestore.instance
    //     .collection('cards')
    //     .doc(currentCardId)
    //     .collection('notifications')
    //     // .doc(currentDocId)
    //     .update(data);

    // add
    // FirebaseFirestore.instance
    //     .collection('cards')
    //     .doc(currentCardId)
    //     .collection('notifications')
    //     // .doc(currentDocId)
    //     .add(notification);

    // queryを使って削除
    // num seconds;
    // num nanoseconds;

    // FirebaseFirestore.instance
    //     .collection('cards')
    //     .doc(currentCardId)
    //     .collection('notifications')
    //     .where('created_at',
    //         isGreaterThan:
    //             Timestamp(seconds = 1664097265, nanoseconds = 000000000))
    //     .where('created_at',
    //         isLessThan:
    //             Timestamp(seconds = 1664097267, nanoseconds = 000000000))
    //     .get()
    //     .then((snapshot) {
    //   snapshot.docs.forEach((element) {
    //     print('$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']}');
    //     element.reference.delete();
    //   });
    // });

    // idを使って削除
    // const messageId = '220925test';

    // FirebaseFirestore.instance
    //     .collection('cards')
    //     .doc(currentCardId)
    //     .collection('notifications')
    //     .where('message_id', isEqualTo: messageId)
    //     .get()
    //     .then((snapshot) {
    //   snapshot.docs.forEach((element) {
    //     print(
    //         '$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']} / ${element['message_id']}');
    //     element.reference.delete();
    //   });
    // });

    //
  });
}
