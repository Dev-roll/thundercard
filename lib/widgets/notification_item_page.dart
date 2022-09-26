import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thundercard/constants.dart';

class NotificationItemPage extends StatefulWidget {
  const NotificationItemPage({
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
  State<NotificationItemPage> createState() => _NotificationItemPageState();
}

class _NotificationItemPageState extends State<NotificationItemPage> {
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
    String displayDateTime = _year + ' ' + _date + ' ' + _time;
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Text(['通知', '交流についての通知', 'アプリに関するお知らせ'][widget.index + 1]),
            Text(['通知', '交流についての通知', 'アプリに関するお知らせ'][0]),
          ],
        ),
        actions: [
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
                  padding: EdgeInsets.fromLTRB(6, 16, 6, 6),
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
                    SizedBox(
                      width: 12,
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 20),
                  child: Text(
                    widget.content,
                    style: TextStyle(
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
