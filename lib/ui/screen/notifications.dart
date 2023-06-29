import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:thundercard/providers/current_card_id_provider.dart';
import 'package:thundercard/providers/notifications_count_provider.dart';
import 'package:thundercard/ui/component/custom_progress_indicator.dart';
import 'package:thundercard/ui/component/notification_item.dart';

class Notifications extends ConsumerStatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  ConsumerState<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<Notifications> {
  @override
  Widget build(BuildContext context) {
    final myCardId = ref.watch(currentCardIdProvider);
    final notificationsCount = ref.watch(notificationsCountProvider);
    final interactionsCount = notificationsCount['interactions_count'];
    final newsCount = notificationsCount['news_count'];

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 8,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          child: SizedBox(
                            width: 120,
                            height: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Badge(
                                  isLabelVisible: interactionsCount != 0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  child: Icon(
                                    Icons.handshake_outlined,
                                    size: 22,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Row(
                                  children: [
                                    Text(
                                      '交流',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.75),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: SizedBox(
                            width: 152,
                            height: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Badge(
                                  isLabelVisible: newsCount != 0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  child: Icon(
                                    Icons.campaign_rounded,
                                    size: 22,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'お知らせ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(width: 2),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('version')
                  .doc('2')
                  .collection('cards')
                  .doc(myCardId)
                  .collection('visibility')
                  .doc('c10r10u10d10')
                  .collection('notifications')
                  .where('tags', arrayContains: 'interaction')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Logger().e('${snapshot.error}');
                  return Text('エラーが発生しました: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomProgressIndicator();
                }

                if (!snapshot.hasData) {
                  return const Text('通知の取得に失敗しました');
                }

                dynamic data = snapshot.data;
                final interactions = data?.docs;
                final interactionsLength = interactions.length;

                return (interactionsLength != 0)
                    ? SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: interactionsLength,
                                  itemBuilder: (context, index) {
                                    DateTime time = interactions[index]
                                            ['created_at']
                                        .toDate();
                                    return Center(
                                      child: NotificationItem(
                                        title: interactions[index]['title'],
                                        content: interactions[index]['content'],
                                        createdAt: time.toString(),
                                        read: interactions[index]['read'],
                                        index: 0,
                                        myCardId: myCardId,
                                        tags: interactions[index]['tags'],
                                        notificationId: interactions[index]
                                            ['notification_id'],
                                        documentId: interactions[index].id,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_paused_rounded,
                              size: 120,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.3),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'まだ交流の通知はありません',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('version')
                  .doc('2')
                  .collection('cards')
                  .doc(myCardId)
                  .collection('visibility')
                  .doc('c10r10u10d10')
                  .collection('notifications')
                  .where('tags', arrayContains: 'news')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Logger().e('${snapshot.error}');
                  return Text('エラーが発生しました: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomProgressIndicator();
                }

                if (!snapshot.hasData) {
                  return const Text('通知の取得に失敗しました');
                }
                dynamic data = snapshot.data;
                final news = data?.docs;
                final newsLength = news.length;

                return (newsLength != 0)
                    ? SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: news.length,
                                  itemBuilder: (context, index) {
                                    DateTime time =
                                        news[index]['created_at'].toDate();
                                    return Center(
                                      child: NotificationItem(
                                        title: news[index]['title'],
                                        content: news[index]['content'],
                                        createdAt: time.toString(),
                                        read: news[index]['read'],
                                        index: 1,
                                        myCardId: myCardId,
                                        tags: news[index]['tags'],
                                        notificationId: news[index]
                                            ['notification_id'],
                                        documentId: news[index].id,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_paused_rounded,
                              size: 120,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.3),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'まだお知らせはありません',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
