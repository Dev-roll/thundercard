import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thundercard/main.dart';
import 'firebase_options.dart';

// MyApp,MyHomePageはデフォルトから変更がないため省略
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 1行目 メールアドレス入力用テキストフィールド
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              // 2行目 パスワード入力用テキストフィールド
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              // 3行目 ユーザー登録ボタン
              ElevatedButton(
                child: const Text('ユーザー登録'),
                onPressed: () async {
                  try {
                    final User? user = (await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password))
                        .user;
                    if (user != null)
                      print("ユーザ登録しました ${user.email} , ${user.uid}");
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              // 4行目 ログインボタン
              ElevatedButton(
                child: const Text('ログイン'),
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final User? user = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                // email: _email, password: _password))
                                email: 'example@example.com', password: 'hogehoge'))
                        .user;
                    if (user != null) {
                      print("ログインしました　${user.email} , ${user.uid}");
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return MyHomePage(
                              title: 'John',
                              type: 'initialType',
                              data: 'initialData',
                              user: user);
                        }),
                      );
                    }
                  } catch (e) {
                    // print(e);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('ログインに失敗しました。'),
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                    ));
                  }
                },
              ),
              // 5行目 パスワードリセット登録ボタン
              ElevatedButton(
                  child: const Text('パスワードリセット'),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _email);
                      print("パスワードリセット用のメールを送信しました");
                    } catch (e) {
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
