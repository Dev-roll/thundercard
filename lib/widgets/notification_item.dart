import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/notification_item_page.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    Key? key,
    required String this.title,
    required String this.content,
    required String this.createdAt,
    required bool this.read,
    int this.index = -1,
  }) : super(key: key);
  final String title;
  final String content;
  final String createdAt;
  final bool read;
  final int index;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  final DateTime _now = DateTime.now();
  Widget build(BuildContext context) {
    final getDateTime = DateTime.parse(widget.createdAt);
    String _year = getDateTime.year.toString();
    String _date =
        getDateTime.month.toString() + '/' + getDateTime.day.toString();
    String _time = getDateTime.hour.toString() +
        ':' +
        getDateTime.minute.toString().padLeft(2, '0');
    String displayDateTime = '';
    displayDateTime +=
        (getDateTime.year != _now.year) ? _year + ' ' + _date : '';
    displayDateTime += (getDateTime.year == _now.year &&
            (getDateTime.month != _now.month || getDateTime.day != _now.day))
        ? _date
        : '';
    displayDateTime += (getDateTime.year == _now.year &&
            getDateTime.month == _now.month &&
            getDateTime.day == _now.day)
        ? _time
        : '';
    var _screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotificationItemPage(
              title: widget.title,
              content: widget.content,
              createdAt: widget.createdAt,
              read: widget.read,
              index: widget.index,
            ),
          ),
        );
      },
      child: Center(
        child: Card(
          elevation: widget.read ? 0 : 4,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: SizedBox(
            width: _screenSize.width * 0.91,
            height: 114,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            style: TextStyle(
                              color: widget.read ? white7 : white,
                              fontSize: 16,
                              height: 1.2,
                              fontWeight: widget.read
                                  ? FontWeight.normal
                                  : FontWeight.w500,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            widget.title,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        displayDateTime,
                        style: TextStyle(
                          color: widget.read
                              ? white7
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: widget.read
                          ? white7
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                      child: Text(widget.content),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
