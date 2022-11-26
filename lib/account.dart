// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/api/current_brightness.dart';
import 'package:thundercard/api/current_brightness_reverse.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/link_auth.dart';
import 'package:thundercard/main.dart';
import 'package:thundercard/widgets/custom_skeletons/skeleton_card_info.dart';
import 'package:thundercard/widgets/my_card.dart';

import 'api/colors.dart';
import 'api/firebase_auth.dart';
import 'home_page.dart';
import 'widgets/card_info.dart';
import 'auth_gate.dart';
// import 'widgets/maintenance.dart';

class Account extends ConsumerWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface),
        statusBarIconBrightness:
            currentBrightnessReverse(Theme.of(context).colorScheme),
        statusBarBrightness: currentBrightness(Theme.of(context).colorScheme),
        statusBarColor: Colors.transparent,
      ),
    );
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final String? uid = getUid();
    final customTheme = ref.watch(customThemeProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: users.doc(uid).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      Map<String, dynamic> user = {};
                      if (snapshot.hasError) {
                        return const Text('問題が発生しました');
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Text('ユーザー情報の取得に失敗しました');
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        user = snapshot.data!.data() as Map<String, dynamic>;
                        return CardInfo(
                            cardId: user['my_cards'][0], editable: true);
                      }

                      return const SkeletonCardInfo();
                    },
                  ),
                ),
                Divider(
                  height: 32,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.settings_rounded,
                          //   color: Theme.of(context)
                          //       .colorScheme
                          //       .onBackground
                          //       .withOpacity(0.7),
                          // ),
                          // SizedBox(
                          //   width: 8,
                          // ),
                          Text(
                            '認証方法',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                      //   child: Row(children: [
                      //     Icon(
                      //       Icons.lock_rounded,
                      //       color:
                      //           Theme.of(context).colorScheme.onSurfaceVariant,
                      //     ),
                      //     SizedBox(
                      //       width: 8,
                      //     ),
                      //     Text(
                      //       '（認証方法）',
                      //       style: TextStyle(
                      //         color: Theme.of(context)
                      //             .colorScheme
                      //             .onSurfaceVariant,
                      //       ),
                      //     ),
                      //   ]),
                      // ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            // Icons.add_link_rounded,
                            Icons.add_circle_outline_rounded,
                          ),
                          // label: const Text('他の認証方法とリンク'),
                          label: const Text('認証方法を追加'),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const LinkAuth()),
                            );
                          },
                          onLongPress: null,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 32,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.settings_rounded,
                          //   color: Theme.of(context)
                          //       .colorScheme
                          //       .onBackground
                          //       .withOpacity(0.7),
                          // ),
                          // SizedBox(
                          //   width: 8,
                          // ),
                          Text(
                            'アプリの設定',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => HomePage(index: 3),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: [
                                  const Icon(Icons.brightness_medium_rounded),
                                  const Icon(Icons.brightness_low_rounded),
                                  const Icon(Icons.brightness_high_rounded),
                                ][customTheme.currentAppThemeIdx],
                                title: const Text('アプリのテーマ'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Divider(
                                      height: 16,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.5),
                                    ),
                                    RadioListTile(
                                      title: const Text('自動切り替え'),
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      value: 0,
                                      groupValue:
                                          customTheme.currentAppThemeIdx,
                                      onChanged: (value) {
                                        customTheme
                                            .appThemeChange(value as int);
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Text('ダークモード'),
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      value: 1,
                                      groupValue:
                                          customTheme.currentAppThemeIdx,
                                      onChanged: (value) {
                                        customTheme
                                            .appThemeChange(value as int);
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Text('ライトモード'),
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      value: 2,
                                      groupValue:
                                          customTheme.currentAppThemeIdx,
                                      onChanged: (value) {
                                        customTheme
                                            .appThemeChange(value as int);
                                      },
                                    ),
                                    Divider(
                                      height: 16,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('キャンセル'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (customTheme.currentAppThemeIdx !=
                                          customTheme.appThemeIdx) {
                                        customTheme.appThemeUpdate();
                                      }
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('決定'),
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            if (customTheme.currentAppThemeIdx !=
                                customTheme.appThemeIdx) {
                              customTheme
                                  .appThemeChange(customTheme.appThemeIdx);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                          child: Row(children: [
                            [
                              Icon(
                                Icons.brightness_medium_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              Icon(
                                Icons.brightness_low_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              Icon(
                                Icons.brightness_high_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ][customTheme.currentAppThemeIdx],
                            const SizedBox(width: 8),
                            Text(
                              'アプリのテーマ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: [
                                  const Text(
                                    '自動切り替え',
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  const Text(
                                    'ダークモード',
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  const Text(
                                    'ライトモード',
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  )
                                ][customTheme.currentAppThemeIdx],
                              ),
                            )
                          ]),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => HomePage(index: 3),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: const Icon(
                                    Icons.settings_brightness_rounded),
                                title: const Text('カードのテーマ'),
                                scrollable: true,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Divider(
                                      height: 16,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.5),
                                    ),
                                    Text(
                                      '現在のプレビュー',
                                      style: TextStyle(
                                        height: 1.6,
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 400,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 4, 0),
                                                child: const FittedBox(
                                                  child: MyCard(
                                                    cardId: 'Light',
                                                    cardType: CardType.preview,
                                                    light: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 0, 0, 0),
                                                child: const FittedBox(
                                                  child: MyCard(
                                                    cardId: 'Dark',
                                                    cardType: CardType.preview,
                                                    light: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 16,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.5),
                                    ),
                                    Column(
                                      children: [
                                        RadioListTile(
                                          title: const Text('オリジナル'),
                                          subtitle: Text(
                                            'カードのテーマを変更せずに表示',
                                            style: TextStyle(
                                              height: 1.6,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          value: 0,
                                          groupValue: customTheme
                                              .currentDisplayCardThemeIdx,
                                          onChanged: (value) {
                                            customTheme
                                                .cardThemeChange(value as int);
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text('自動切り替え'),
                                          subtitle: Text(
                                            'アプリと同じテーマでカードを表示',
                                            style: TextStyle(
                                              height: 1.6,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          value: 1,
                                          groupValue: customTheme
                                              .currentDisplayCardThemeIdx,
                                          onChanged: (value) {
                                            customTheme
                                                .cardThemeChange(value as int);
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text('ダークモード'),
                                          subtitle: Text(
                                            'カードをダークモードで表示',
                                            style: TextStyle(
                                              height: 1.6,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          value: 2,
                                          groupValue: customTheme
                                              .currentDisplayCardThemeIdx,
                                          onChanged: (value) {
                                            customTheme
                                                .cardThemeChange(value as int);
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text('ライトモード'),
                                          subtitle: Text(
                                            'カードをライトモードで表示',
                                            style: TextStyle(
                                              height: 1.6,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          value: 3,
                                          groupValue: customTheme
                                              .currentDisplayCardThemeIdx,
                                          onChanged: (value) {
                                            customTheme
                                                .cardThemeChange(value as int);
                                          },
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 16,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('キャンセル'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (customTheme
                                              .currentDisplayCardThemeIdx !=
                                          customTheme.displayCardThemeIdx) {
                                        customTheme.cardThemeUpdate();
                                      }
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('決定'),
                                  )
                                ],
                              );
                            },
                          ).then((value) {
                            if (customTheme.currentDisplayCardThemeIdx !=
                                customTheme.displayCardThemeIdx) {
                              customTheme.cardThemeChange(
                                  customTheme.displayCardThemeIdx);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                          child: Row(children: [
                            Icon(
                              Icons.settings_brightness_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'カードのテーマ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: [
                                  const Text(
                                    'オリジナル',
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  const Text(
                                    '自動切り替え',
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  const Text(
                                    'ダークモード',
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                  const Text(
                                    'ライトモード',
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  )
                                ][customTheme.currentDisplayCardThemeIdx],
                              ),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 32,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'アプリ内のデータ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            // ElevatedButton.icon(
                            //   icon: const Icon(
                            //     Icons.save_alt_rounded,
                            //   ),
                            //   label: const Text('端末にダウンロード'),
                            //   style: ElevatedButton.styleFrom(
                            //     elevation: 0,
                            //     foregroundColor: Theme.of(context)
                            //         .colorScheme
                            //         .onSecondaryContainer,
                            //     backgroundColor: Theme.of(context)
                            //         .colorScheme
                            //         .secondaryContainer,
                            //   ),
                            //   onPressed: () async {
                            //     final path =
                            //         await getApplicationDocumentsDirectory()
                            //             .then((value) => value.path);
                            //     Share.shareFiles(
                            //       [
                            //         '$path/appThemeIdx.txt',
                            //       ],
                            //       text: 'usernameのデータ',
                            //       subject: 'usernameさんのデータの共有',
                            //     );
                            //   },
                            //   onLongPress: null,
                            // ),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.share_rounded,
                              ),
                              label: const Text('データを共有'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              onPressed: () async {
                                final path =
                                    await getApplicationDocumentsDirectory()
                                        .then((value) => value.path);
                                Share.shareFiles(
                                  [
                                    // '$path/list.txt',
                                    '$path/appThemeIdx.txt',
                                    '$path/displayCardThemeIdx.txt',
                                  ],
                                  text: 'Thundercardアプリのデータ',
                                  subject: 'Thundercardアプリのデータ共有',
                                );
                              },
                              onLongPress: null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 32,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 28,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.logout_rounded,
                  ),
                  label: const Text('サインアウト'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(1),
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      // (3) AlertDialogを作成する
                      builder: (context) => AlertDialog(
                        icon: const Icon(Icons.logout_rounded),
                        title: const Text('サインアウト'),
                        content: Text(
                          'このアカウントからサインアウトしますか？',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        // (4) ボタンを設定
                        actions: [
                          TextButton(
                              onPressed: () => {
                                    //  (5) ダイアログを閉じる
                                    Navigator.pop(context, false)
                                  },
                              onLongPress: null,
                              child: const Text('キャンセル')),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, true);
                              await FirebaseAuth.instance.signOut().then(
                                    (value) => Navigator.of(context)
                                        .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => AuthGate(),
                                      ),
                                      (_) => false,
                                    ),
                                  );
                            },
                            onLongPress: null,
                            child: const Text('サインアウト'),
                          ),
                        ],
                      ),
                    );
                  },
                  onLongPress: null,
                ),
                const SizedBox(height: 28),
                Divider(
                  height: 32,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                const SizedBox(height: 28),
                OutlinedButton.icon(
                  icon: const Icon(
                    Icons.person_off_rounded,
                  ),
                  label: const Text('アカウントを削除'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Theme.of(context).colorScheme.error,
                    // backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      // (3) AlertDialogを作成する
                      builder: (context) => AlertDialog(
                        icon: const Icon(Icons.person_off_rounded),
                        title: Text('アカウントを削除'),
                        content: Text(
                          'このアカウントを削除しますか？',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        // (4) ボタンを設定
                        actions: [
                          TextButton(
                              onPressed: () => {
                                    //  (5) ダイアログを閉じる
                                    Navigator.pop(context, false)
                                  },
                              onLongPress: null,
                              child: const Text('キャンセル')),
                          TextButton(
                            onPressed: () async {
                              final data = {
                                'uid': uid,
                                'createdAt': Timestamp.now(),
                              };
                              await FirebaseFirestore.instance
                                  .collection('deleted_users')
                                  .add(data)
                                  .then((value) async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => AuthGate()),
                                );
                              }).catchError((e) =>
                                      debugPrint('Failed to add user: $e'));
                            },
                            onLongPress: null,
                            child: Text(
                              'アカウントを削除',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onLongPress: null,
                ),
                // OutlinedButton(
                //   onPressed: () async {
                //     final data = {
                //       "uid": uid,
                //       "createdAt": Timestamp.now(),
                //     };
                //     await FirebaseFirestore.instance
                //         .collection('deleted_users')
                //         .add(data)
                //         .then((value) async {
                //       await FirebaseAuth.instance.signOut();
                //       Navigator.of(context).pushReplacement(
                //         MaterialPageRoute(builder: (context) => AuthGate()),
                //       );
                //     }).catchError((e) => print("Failed to add user: $e"));
                //   },
                //   child: Text('退会する'),
                // ),
                // メンテナンス
                // const SizedBox(height: 28),
                // const OutlinedButton(
                //   onPressed: maintenance,
                //   onLongPress: null,
                //   child: Text('管理者用'),
                // ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
