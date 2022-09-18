import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/notification_item.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final _notificationPrivate = 'hoge';
  final _notificationPublic = '1 2 3 4';
  final _notificationPrivateData = 1;
  final _notificationPublicData = null;
  final _notificationPrivateNum = 3;
  final _notificationPublicNum = 0;

  @override
  Widget build(BuildContext context) {
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
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          // child: Icon(Icons.notifications_on_rounded),
                          child: Container(
                            width: 120,
                            height: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
            (_notificationPrivateData != null)
                ? SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('chat_room')
                                  .doc(_notificationPrivate)
                                  .collection('contents')
                                  .doc('cLNIkm5mn0Ul7mKidrOK')
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

                                dynamic hoge = snapshot.data;
                                DateTime time =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        hoge['createdAt']);
                                // 取得したデータを表示するWidget
                                return NotificationItem(
                                  title: hoge?['name'],
                                  content: hoge?['text'],
                                  createdAt: time.toString(),
                                  read: false,
                                  index: 0,
                                );
                                // return Column(
                                //   children: [
                                // Text(hoge),
                                // ListView.builder(itemBuilder: hoge),
                                // Text('username: ${hoge?['text']}'),
                                // Text('username: ${hoge?['name']}'),
                                // Text('bio: ${hoge?['bio']}'),
                                // Text('URL: ${hoge?['url']}'),
                                // Text('Twitter: ${hoge?['twitter']}'),
                                // Text('GitHub: ${hoge?['github']}'),
                                // Text('company: ${hoge?['company']}'),
                                // Text('email: ${hoge?['email']}'),
                                // Image.network(hoge?['thumbnail']),
                                // ],
                                // );
                              },
                            ),
                            NotificationItem(
                              title: 'タイトル',
                              content: '通知の内容が書かれています。カードをタップして、内容を見てみましょう！',
                              createdAt: '2022-09-19 20:06:43.946',
                              read: false,
                              index: 0,
                            ),
                            NotificationItem(
                              title: '○○について- abcdefghijklmnopqrstuvwxyz',
                              content: '○○についての通知が10件あります。詳細はこちらから。',
                              createdAt: '2022-09-18 20:06:43.946',
                              read: false,
                              index: 0,
                            ),
                            NotificationItem(
                              title: 'CardsEditorさんが追加されました！',
                              content: 'QRコードでCardsEditorさんと名刺交換されました！',
                              createdAt: '2021-09-15 20:06:43.946',
                              read: true,
                              index: 0,
                            ),
                            NotificationItem(
                              title: 'hogehogeさんからの申請',
                              content:
                                  'hogehogeさんから、名刺交換の申請が届きました。申請を確認してみましょう。※なりすましの申請に注意してください。報告はこちらから。',
                              createdAt: '2021-04-18 20:06:43.946',
                              read: true,
                              index: 0,
                            ),
                            NotificationItem(
                              title: 'piyopiyoさんからのメッセージ',
                              content:
                                  'piyopiyoさんから、メッセージが届きました。メッセージを確認してください。',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: false,
                              index: 0,
                            ),
                            NotificationItem(
                              title: 'title',
                              content: 'content',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 0,
                            ),
                            NotificationItem(
                              title:
                                  'super_____long_____usernameさんから、非常に長いメッセージが届きました',
                              content:
                                  'super_____long_____usernameさんから、非常に長いメッセージが届きました。\nsuper_____long_____usernameさんから、非常に長いメッセージが届きました。\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n私は一生おっつけ同じ出入り院というののためにするただろ。はなはだ時間に安住通りはほぼその学習うたばかりを潜んがいますにも反対思っないならて、それだけにはなっでなたた。本位を伺いた点もまあ今日をけっしてんたろない。ひょろひょろ木下さんに奨励ただはっきり攻撃で使うあり春この個人私か病気でってご学習たないだろますて、その元来はよそか本位肴をあるて、久原さんの訳へ議会の誰が同時に同研究と突き破って何礼よりお学問を云っようにかつてご希望へ過ぎでたので、よく何でもかでも話がいうましからいるでものが云うたな。またはただお自分があるものは多少自然と参りですて、そのベンチへは認めるたてという中腰からなっば行くましです。\n\nsuper_____long_____usernameさんからのメッセージ。',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 0,
                            ),
                            NotificationItem(
                              title: 'title',
                              content: 'content',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 0,
                            ),
                            NotificationItem(
                              title: 'title',
                              content: 'content',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 0,
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
                          color: white5,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'まだ交流の通知はありません',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
            (_notificationPublicData != null)
                ? SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NotificationItem(
                              title: 'タイトル',
                              content: '通知の内容が書かれています。カードをタップして、内容を見てみましょう！',
                              createdAt: '2022-09-19 20:06:43.946',
                              read: false,
                              index: 1,
                            ),
                            NotificationItem(
                              title: '○○について- abcdefghijklmnopqrstuvwxyz',
                              content: '○○についての通知が10件あります。詳細はこちらから。',
                              createdAt: '2022-09-18 20:06:43.946',
                              read: false,
                              index: 1,
                            ),
                            NotificationItem(
                              title: 'CardsEditorさんが追加されました！',
                              content: 'QRコードでCardsEditorさんと名刺交換されました！',
                              createdAt: '2021-09-15 20:06:43.946',
                              read: true,
                              index: 1,
                            ),
                            NotificationItem(
                              title: 'hogehogeさんからの申請',
                              content:
                                  'hogehogeさんから、名刺交換の申請が届きました。申請を確認してみましょう。※なりすましの申請に注意してください。報告はこちらから。',
                              createdAt: '2021-04-18 20:06:43.946',
                              read: true,
                              index: 1,
                            ),
                            NotificationItem(
                              title: 'piyopiyoさんからのメッセージ',
                              content:
                                  'piyopiyoさんから、メッセージが届きました。メッセージを確認してください。',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: false,
                              index: 1,
                            ),
                            NotificationItem(
                              title: 'title',
                              content: 'content',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 1,
                            ),
                            NotificationItem(
                              title:
                                  'super_____long_____usernameさんから、非常に長いメッセージが届きました',
                              content:
                                  'super_____long_____usernameさんから、非常に長いメッセージが届きました。\nsuper_____long_____usernameさんから、非常に長いメッセージが届きました。\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n私は一生おっつけ同じ出入り院というののためにするただろ。はなはだ時間に安住通りはほぼその学習うたばかりを潜んがいますにも反対思っないならて、それだけにはなっでなたた。本位を伺いた点もまあ今日をけっしてんたろない。ひょろひょろ木下さんに奨励ただはっきり攻撃で使うあり春この個人私か病気でってご学習たないだろますて、その元来はよそか本位肴をあるて、久原さんの訳へ議会の誰が同時に同研究と突き破って何礼よりお学問を云っようにかつてご希望へ過ぎでたので、よく何でもかでも話がいうましからいるでものが云うたな。またはただお自分があるものは多少自然と参りですて、そのベンチへは認めるたてという中腰からなっば行くましです。\n\nsuper_____long_____usernameさんからのメッセージ。',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 1,
                            ),
                            NotificationItem(
                              title: 'title',
                              content: 'content',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 1,
                            ),
                            NotificationItem(
                              title: 'title',
                              content: 'content',
                              createdAt: '2020-09-18 20:06:43.946',
                              read: true,
                              index: 1,
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
                          color: white5,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'まだお知らせはありません',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
