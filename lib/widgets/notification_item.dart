import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notification_item_page.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
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
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final getDateTime = DateTime.parse(widget.createdAt);
    String year = getDateTime.year.toString();
    String date = '${getDateTime.month}/${getDateTime.day}';
    String time =
        '${getDateTime.hour}:${getDateTime.minute.toString().padLeft(2, '0')}';
    String displayDateTime = '';
    displayDateTime += (getDateTime.year != now.year) ? '$year $date' : '';
    displayDateTime += (getDateTime.year == now.year &&
            (getDateTime.month != now.month || getDateTime.day != now.day))
        ? date
        : '';
    displayDateTime += (getDateTime.year == now.year &&
            getDateTime.month == now.month &&
            getDateTime.day == now.day)
        ? time
        : '';
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        debugPrint(widget.documentId);
        FirebaseFirestore.instance
            .collection('version')
            .doc('2')
            .collection('cards')
            .doc(widget.myCardId)
            .collection('visibility')
            .doc('c10r10u10d10')
            .collection('notifications')
            .doc(widget.documentId)
            .update({'read': true});

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotificationItemPage(
              title: widget.title,
              content: widget.content,
              createdAt: widget.createdAt,
              read: widget.read,
              index: widget.index,
              myCardId: widget.myCardId,
              tags: widget.tags,
              notificationId: widget.notificationId,
              documentId: widget.documentId,
            ),
          ),
        );
      },
      child: Card(
        elevation: widget.read ? 0 : 4,
        color: widget.read
            ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5)
            : Theme.of(context).colorScheme.surfaceVariant,
        child: SizedBox(
          width: min(screenSize.width * 0.91, 800),
          height: 114,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        style: TextStyle(
                          color: widget.read
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5)
                              : Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                          height: 1.2,
                          fontWeight:
                              widget.read ? FontWeight.normal : FontWeight.w500,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        widget.title,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      displayDateTime,
                      style: TextStyle(
                        color: widget.read
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5)
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!widget.read) const SizedBox(width: 6),
                    if (!widget.read)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                  ],
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    color: widget.read
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(widget.content),
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
