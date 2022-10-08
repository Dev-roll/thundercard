import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thundercard/api/current_brightness.dart';
import 'package:thundercard/api/current_brightness_reverse.dart';
import 'package:thundercard/widgets/avatar.dart';

import 'api/colors.dart';
import 'api/firebase_auth.dart';
import 'widgets/card_info.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/maintenance.dart';
import 'auth_gate.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final String? uid = getUid();

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: users.doc(uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("問題が発生しました");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("ユーザー情報の取得に失敗しました");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> user =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: CardInfo(
                            cardId: user['my_cards'][0], editable: true),
                      );
                    }
                    return const Center(child: CustomProgressIndicator());
                  },
                ),
                Divider(
                  height: 32,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'アプリの設定',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.logout_rounded,
                  ),
                  label: const Text('サインアウト'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(1),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        // (3) AlertDialogを作成する
                        builder: (context) => AlertDialog(
                              icon: Icon(Icons.logout_rounded),
                              title: Text("サインアウト"),
                              content: Text(
                                "このアカウントからサインアウトしますか？",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
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
                                    child: Text("キャンセル")),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context, true);
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => AuthGate(),
                                        ),
                                        (_) => false,
                                      );
                                    },
                                    onLongPress: null,
                                    child: Text("サインアウト")),
                              ],
                            ));
                  },
                  onLongPress: null,
                ),
                // メンテナンス
                SizedBox(height: 40),
                OutlinedButton(
                  onPressed: maintenance,
                  onLongPress: null,
                  child: Text('管理者用'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
