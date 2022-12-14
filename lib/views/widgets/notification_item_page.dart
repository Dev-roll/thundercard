import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../pages/add_card.dart';
import '../pages/home_page.dart';

class NotificationItemPage extends ConsumerWidget {
  const NotificationItemPage({
    Key? key,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.read,
    this.index = -1,
    required this.myCardId,
    required this.tags,
    required this.notificationId,
    required this.documentId,
  }) : super(key: key);
  final String title;
  final String content;
  final String createdAt;
  final bool read;
  final int index;
  final String myCardId;
  final List tags;
  final String notificationId;
  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getDateTime = DateTime.parse(createdAt);
    String year = getDateTime.year.toString();
    String date = '${getDateTime.month}/${getDateTime.day}';
    String time =
        '${getDateTime.hour}:${getDateTime.minute.toString().padLeft(2, '0')}';
    String displayDateTime = '$year $date $time';
    final notificationItemDoc = FirebaseFirestore.instance
        .collection('version')
        .doc('2')
        .collection('cards')
        .doc(myCardId)
        .collection('visibility')
        .doc('c10r10u10d10')
        .collection('notifications')
        .doc(documentId);

    void deleteThisNotification() {
      debugPrint(documentId);
      notificationItemDoc.delete().then(
        (doc) {
          ref.watch(currentIndexProvider.notifier).state = 2;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (_) => false,
          );
          debugPrint('Document deleted');
        },
        onError: (e) {
          debugPrint('Error updating document $e');
        },
      );
    }

    Future openAlertDialog1(BuildContext context) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.delete_rounded),
          title: const Text('???????????????'),
          content: Text(
            '????????????????????????????????????',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('???????????????'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteThisNotification();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
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
              if (s == '???????????????') {
                FirebaseFirestore.instance
                    .collection('version')
                    .doc('2')
                    .collection('cards')
                    .doc(myCardId)
                    .collection('visibility')
                    .doc('c10r10u10d10')
                    .collection('notifications')
                    .doc(documentId)
                    .update({'read': false}).then(
                  (doc) {
                    ref.watch(currentIndexProvider.notifier).state = 2;

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                      (_) => false,
                    );
                  },
                  onError: (e) {
                    debugPrint('Error updating document $e');
                  },
                );
              } else if (s == '??????') {
                openAlertDialog1(context);
              }
            },
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(6, 16, 6, 6),
                        child: Text(
                          title,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 20,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            displayDateTime,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.5),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 60),
                        child: Text(
                          content,
                          style: const TextStyle(
                            height: 1.8,
                          ),
                        ),
                      ),
                      if (tags.contains('apply'))
                        // verified
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('??????'),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomePage();
                                    },
                                  ),
                                );
                              }
                              notificationItemDoc.set({
                                'tags': FieldValue.arrayRemove(['apply'])
                              }, SetOptions(merge: true));
                              notificationItemDoc.set({
                                'tags': FieldValue.arrayUnion(['applied'])
                              }, SetOptions(merge: true));
                              verifyCard(myCardId, notificationId);
                            },
                          ),
                        ),
                      if (tags.contains('applied'))
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(
                                Icons.published_with_changes_rounded),
                            label: const Text('????????????'),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
