import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/colors.dart';
import 'api/firebase_auth.dart';
import 'widgets/notification_item.dart';
import 'custom_progress_indicator.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // final myCardId = 'example';
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');
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
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> user =
                snapshot.data!.data() as Map<String, dynamic>;
            final myCardId = user['my_cards'][0];
            return DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(Platform.isAndroid
                      ? 40 + MediaQuery.of(context).padding.top
                      : MediaQuery.of(context).padding.top),
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
                            decoration: BoxDecoration(
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
                                  child: Container(
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
                                        SizedBox(
                                          width: 6,
                                        ),
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
                                        SizedBox(
                                          width: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
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
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          'お知らせ',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer
                                                .withOpacity(0.75),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
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
                            .collection('cards')
                            .doc(myCardId)
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
                            print(snapshot.error);
                            return Text('error');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomProgressIndicator();
                          }

                          // データが取得できなかったときに表示するWidget
                          if (!snapshot.hasData) {
                            return Text('no data');
                          }

                          dynamic data = snapshot.data;
                          final interactions = data?.docs;
                          final interactions_length = interactions.length;

                          return (interactions_length != 0)
                              ? SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 12, 0, 16),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: interactions_length,
                                              itemBuilder: (context, index) {
                                                DateTime time =
                                                    interactions[index]
                                                            ['created_at']
                                                        .toDate();
                                                return NotificationItem(
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
                                      SizedBox(
                                        height: 20,
                                      ),
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
                            .collection('cards')
                            .doc(myCardId)
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
                            print(snapshot.error);
                            return Text('error');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomProgressIndicator();
                          }

                          // データが取得できなかったときに表示するWidget
                          if (!snapshot.hasData) {
                            return Text('no data');
                          }
                          dynamic data = snapshot.data;
                          final news = data?.docs;
                          final news_length = news.length;

                          return (news_length != 0)
                              ? SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 12, 0, 16),
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
                                                return NotificationItem(
                                                  title: news[index]['title'],
                                                  content: news[index]
                                                      ['content'],
                                                  createdAt: time.toString(),
                                                  read: news[index]['read'],
                                                  index: 1,
                                                  myCardId: myCardId,
                                                  documentId:
                                                      news[index].id,
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
                                      SizedBox(
                                        height: 20,
                                      ),
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
