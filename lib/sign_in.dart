import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:thundercard/auth_gate.dart';

import 'home_page.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = '';
  String password = '';
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();

  Future _onSignInWithAnonymousUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInAnonymously();

      return HomePage(
        index: 0,
      );
    } catch (e) {
      // await showsnac(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Text('エラー'),
      //         content: Text(e.toString()),
      //       );
      //     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'サインイン',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Icon(
                      Icons.login,
                      size: 32,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: true,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.mail),
                              hintText: 'example@example.com',
                              labelText: 'メールアドレス',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'メールアドレスが入力されていません';
                              }
                              if (!value.contains('@')) {
                                return 'メールアドレスが正しくありません';
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: hidePassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock),
                              labelText: 'パスワード',
                              suffixIcon: IconButton(
                                splashRadius: 20,
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                            ),
                            maxLength: 64,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'パスワードが入力されていません';
                              }
                              if (value.length < 8) {
                                return '8文字以上にしてください';
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              onPrimary: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            onPressed:
                                !email.contains('@') || password.length < 8
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          // サインインの処理を書く
                                          () async {
                                            try {
                                              await FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                                      email: email,
                                                      password: password);

                                              return AuthGate();
                                            } catch (e) {
                                              debugPrint('$e');
                                            }
                                          }();

                                          // if (true) {
                                          //   // うまくいった場合は画面遷移
                                          //   Navigator.of(context).pushReplacement(
                                          //     MaterialPageRoute(
                                          //         builder: (context) => App()),
                                          //   );
                                          // }
                                        }
                                      },
                            child: const Text('サインイン'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    GoogleSignInButton(
                        clientId:
                            '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com'),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'アカウント未登録の場合は',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                                height: 40,
                              ),
                              Icon(
                                Icons.person_add_alt,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'サインアップ',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
