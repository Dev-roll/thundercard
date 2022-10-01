import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thundercard/api/current_brightness.dart';
import 'package:thundercard/api/current_brightness_reverse.dart';

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
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: users.doc(uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> user =
                    snapshot.data!.data() as Map<String, dynamic>;

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CardInfo(
                            cardId: user['my_cards'][0], editable: true),
                      ),
                    ),
                  ),
                );
              }
              return const Center(child: CustomProgressIndicator());
            },
          ),
          ElevatedButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    // (3) AlertDialogを作成する
                    builder: (context) => AlertDialog(
                          title: Text("Sign out"),
                          content: Text("このアカウントからサインアウトしますか？"),
                          // (4) ボタンを設定
                          actions: [
                            TextButton(
                                onPressed: () => {
                                      //  (5) ダイアログを閉じる
                                      Navigator.pop(context, false)
                                    },
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
                                child: Text("OK")),
                          ],
                        ));
              },
              child: const Text('Sign out')),
          // メンテナンス
          SizedBox(height: 40),
          OutlinedButton(onPressed: maintenance, child: Text('maintenance'))
        ],
      ),
    );
  }
}
