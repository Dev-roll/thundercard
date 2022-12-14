import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/colors.dart';
import 'api/firebase_auth.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/notification_item.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // final myCardId = 'example';
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference cards = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards');
  Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface),
        statusBarColor: Colors.transparent,
      ),
    );
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).collection('card').doc('current_card').get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('問題が発生しました');
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text('ユーザー情報の取得に失敗しました');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> currentCard =
                snapshot.data!.data() as Map<String, dynamic>;
            final myCardId = currentCard['current_card'];
            return DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(72),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    // backgroundColor: Theme.of(context).colorScheme.background,
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: [
                                Tab(
                                  // child: Icon(Icons.notifications_on_rounded),
                                  child: SizedBox(
                                    width: 120,
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.handshake_outlined,
                                          // Icons.mail_rounded,
                                          // Icons.swap_horiz_rounded,
                                          // Icons.swap_horizontal_circle_rounded,
                                          size: 22,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer
                                              .withOpacity(0.75),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '交流',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer
                                                .withOpacity(0.75),
                                          ),
                                        ),
                                        // Text('つながり'),
                                        // Text('やりとり'),
                                        const SizedBox(width: 2),
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: SizedBox(
                                    width: 152,
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.campaign_rounded,
                                          size: 22,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer
                                              .withOpacity(0.75),
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
                          // 取得が完了していないときに表示するWidget
                          // if (snapshot.connectionState != ConnectionState.done) {
                          //   // インジケーターを回しておきます
                          //   return const CircularProgressIndicator();
                          // }

                          // エラー時に表示するWidget
                          if (snapshot.hasError) {
                            debugPrint('${snapshot.error}');
                            return Text('エラーが発生しました: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomProgressIndicator();
                          }

                          // データが取得できなかったときに表示するWidget
                          if (!snapshot.hasData) {
                            return const Text('通知の取得に失敗しました');
                          }

                          dynamic data = snapshot.data;
                          final interactions = data?.docs;
                          final interactionsLength = interactions.length;

                          return (interactionsLength != 0)
                              ? SingleChildScrollView(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 16),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: interactionsLength,
                                              itemBuilder: (context, index) {
                                                DateTime time =
                                                    interactions[index]
                                                            ['created_at']
                                                        .toDate();
                                                return Center(
                                                  child: NotificationItem(
                                                    title: interactions[index]
                                                        ['title'],
                                                    content: interactions[index]
                                                        ['content'],
                                                    createdAt: time.toString(),
                                                    read: interactions[index]
                                                        ['read'],
                                                    index: 0,
                                                    myCardId: myCardId,
                                                    documentId:
                                                        interactions[index].id,
                                                  ),
                                                );
                                              }),
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
                                                .onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                );
                        }),
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
                          // 取得が完了していないときに表示するWidget
                          // if (snapshot.connectionState != ConnectionState.done) {
                          //   // インジケーターを回しておきます
                          //   return const CircularProgressIndicator();
                          // }

                          // エラー時に表示するWidget
                          if (snapshot.hasError) {
                            debugPrint('${snapshot.error}');
                            return Text('エラーが発生しました: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomProgressIndicator();
                          }

                          // データが取得できなかったときに表示するWidget
                          if (!snapshot.hasData) {
                            return const Text('通知の取得に失敗しました');
                          }
                          dynamic data = snapshot.data;
                          final news = data?.docs;
                          final newsLength = news.length;

                          return (newsLength != 0)
                              ? SingleChildScrollView(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 16),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: news.length,
                                              itemBuilder: (context, index) {
                                                DateTime time = news[index]
                                                        ['created_at']
                                                    .toDate();
                                                return Center(
                                                  child: NotificationItem(
                                                    title: news[index]['title'],
                                                    content: news[index]
                                                        ['content'],
                                                    createdAt: time.toString(),
                                                    read: news[index]['read'],
                                                    index: 1,
                                                    myCardId: myCardId,
                                                    documentId: news[index].id,
                                                  ),
                                                );
                                              }),
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
                                                .onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                );
                        }),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CustomProgressIndicator()),
          );
        });
  }
}
