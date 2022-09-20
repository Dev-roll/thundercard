import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/notification_item.dart';

import 'api/firebase_auth.dart';

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
                  preferredSize:
                      Size.fromHeight(40 + MediaQuery.of(context).padding.top),
                  child: AppBar(
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
                                          color: seedColorLightA,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text('交流'),
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
                                          color: seedColorLightA,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text('お知らせ'),
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
                            return const Text("Loading");
                          }

                          // データが取得できなかったときに表示するWidget
                          if (!snapshot.hasData) {
                            return Text('no data');
                          }
                          dynamic data = snapshot.data;
                          final interactions = data?['interactions'];
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
                                              itemCount: interactions.length,
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
                                        color: white5,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'まだ交流の通知はありません',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                      ),
                                    ],
                                  ),
                                );
                        }),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('news')
                            .doc('news_items')
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
                            return const Text("Loading");
                          }

                          // データが取得できなかったときに表示するWidget
                          if (!snapshot.hasData) {
                            return Text('no data');
                          }
                          dynamic data = snapshot.data;
                          final news_list = data?['news_list'];
                          final news_list_length = news_list.length;

                          return (news_list_length != 0)
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
                                              itemCount: news_list.length,
                                              itemBuilder: (context, index) {
                                                DateTime time = news_list[index]
                                                        ['created_at']
                                                    .toDate();
                                                return NotificationItem(
                                                  title: news_list[index]
                                                      ['title'],
                                                  content: news_list[index]
                                                      ['content'],
                                                  createdAt: time.toString(),
                                                  read: news_list[index]
                                                      ['read'],
                                                  index: 1,
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
                                        color: white5,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'まだお知らせはありません',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
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
          return const Text("Loading");
        });
  }
}
