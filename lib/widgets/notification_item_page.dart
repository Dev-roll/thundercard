import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';

import '../api/colors.dart';
import '../home_page.dart';

class NotificationItemPage extends StatefulWidget {
  const NotificationItemPage({
    Key? key,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.read,
    this.index = -1,
    required this.myCardId,
    required this.documentId,
  }) : super(key: key);
  final String title;
  final String content;
  final String createdAt;
  final bool read;
  final int index;
  final String myCardId;
  final String documentId;

  @override
  State<NotificationItemPage> createState() => _NotificationItemPageState();
}

class _NotificationItemPageState extends State<NotificationItemPage> {
  @override
  Widget build(BuildContext context) {
    final getDateTime = DateTime.parse(widget.createdAt);
    String year = getDateTime.year.toString();
    String date = '${getDateTime.month}/${getDateTime.day}';
    String time =
        '${getDateTime.hour}:${getDateTime.minute.toString().padLeft(2, '0')}';
    String displayDateTime = '$year $date $time';
    // displayDateTime +=
    //     (getDateTime.year != _now.year) ? _year + ' ' + _date : '';
    // displayDateTime += (getDateTime.year == _now.year &&
    //         (getDateTime.month != _now.month || getDateTime.day != _now.day))
    //     ? _date
    //     : '';
    // displayDateTime += (getDateTime.year == _now.year &&
    //         getDateTime.month == _now.month &&
    //         getDateTime.day == _now.day)
    //     ? _time
    //     : '';
    var _screenSize = MediaQuery.of(context).size;

    void deleteThisNotification() {
      debugPrint(widget.documentId);
      FirebaseFirestore.instance
          .collection('cards')
          .doc(widget.myCardId)
          .collection('notifications')
          .doc(widget.documentId)
          .delete()
          .then(
        (doc) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(index: 2),
            ),
            (_) => false,
          );
          debugPrint("Document deleted");
        },
        onError: (e) => debugPrint("Error updating document $e"),
      );
    }

    Future openAlertDialog1(BuildContext context) async {
      // (2) showDialogでダイアログを表示する
      await showDialog(
          context: context,
          // (3) AlertDialogを作成する
          builder: (context) => AlertDialog(
                icon: const Icon(Icons.delete_rounded),
                title: const Text("通知の削除"),
                content: Text(
                  "この通知を削除しますか？",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                // (4) ボタンを設定
                actions: [
                  TextButton(
                      onPressed: () => {
                            //  (5) ダイアログを閉じる
                            Navigator.pop(context, false)
                          },
                      child: const Text("キャンセル")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        deleteThisNotification();
                      },
                      child: const Text("OK")),
                ],
              ));
    }

    return Scaffold(
      appBar: AppBar(
        // title: Row(
        //   children: [
        //     // Text(['通知', '交流についての通知', 'アプリに関するお知らせ'][widget.index + 1]),
        //     Text(['通知', '交流についての通知', 'アプリに関するお知らせ'][0]),
        //   ],
        // ),
        actions: [
          PopupMenuButton<String>(
            color: alphaBlend(
              Theme.of(context).colorScheme.primary.withOpacity(0.08),
              Theme.of(context).colorScheme.surface,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            splashRadius: 20,
            elevation: 8,
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) {
              return menuItmNotificationItemPage.map((String s) {
                return PopupMenuItem(
                  value: s,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      menuIcnNotificationItemPage[
                          menuItmNotificationItemPage.indexOf(s)],
                      const SizedBox(width: 8),
                      Text(
                        s,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (String s) {
              if (s == "未読にする") {
                FirebaseFirestore.instance
                    .collection('cards')
                    .doc(widget.myCardId)
                    .collection('notifications')
                    .doc(widget.documentId)
                    .update({'read': false}).then(
                  (doc) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomePage(index: 2),
                      ),
                      (_) => false,
                    );
                  },
                  onError: (e) => debugPrint("Error updating document $e"),
                );
              } else if (s == "削除") {
                openAlertDialog1(context);
              }
              // if (s == '削除') {
              //   _openAlertDialog1(context);
              // }
            },
          )
          // Container(
          //   padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.more_vert_rounded),
          //   ),
          // ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 16, 6, 6),
                  child: Text(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 20,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                    widget.title,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      displayDateTime,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 2,
                      ),
                    ),
                    const SizedBox(width: 12)
                  ],
                ),
                Divider(
                  height: 24,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
                  child: Text(
                    widget.content,
                    style: const TextStyle(
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
