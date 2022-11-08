import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thundercard/auth_gate.dart';

import 'sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.email, required this.password})
      : super(key: key);
  final String email;
  final String password;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final TextEditingController _emailController =
      TextEditingController(text: widget.email);
  late final TextEditingController _passwordController =
      TextEditingController(text: widget.password);
  String passwordCheck = '';
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();

  Future _onSignInWithAnonymousUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInAnonymously();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthGate()),
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

  Future<void> _onSignInGoogle() async {
    try {
      final googleLogin = GoogleSignIn(scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ]);

      GoogleSignInAccount? signinAccount = await googleLogin.signIn();
      if (signinAccount == null) return;

      GoogleSignInAuthentication auth = await signinAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    } catch (e) {
      // await showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Text('エラー'),
      //         content: Text(e.toString()),
      //       );
      //     }
      // );
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
                    const Text(
                      'サインアップ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Icon(
                      Icons.person_add_alt,
                      size: 32,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: true,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.mail_rounded),
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
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: hidePassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock_rounded),
                              labelText: 'パスワード',
                              suffixIcon: IconButton(
                                splashRadius: 20,
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
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
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: hidePassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock_rounded),
                              labelText: 'パスワード（確認用）',
                              suffixIcon: IconButton(
                                splashRadius: 20,
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
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
                                passwordCheck = value;
                              });
                            },
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: !_emailController.text.contains('@') ||
                                    _passwordController.text.length < 8 ||
                                    passwordCheck.length < 8 ||
                                    _passwordController.text != passwordCheck
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      try {
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text)
                                            .then((value) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthGate()),
                                          );
                                        });
                                      } catch (e) {
                                        debugPrint('$e');
                                      }
                                      // if (true) {
                                      //   // うまくいった場合は画面遷移
                                      //   Navigator.of(context).pushReplacement(
                                      //     MaterialPageRoute(
                                      //         builder: (context) => App()),
                                      //   );
                                      // }
                                    }
                                  },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 8),
                                Icon(Icons.person_add_alt),
                                SizedBox(width: 8),
                                Text('サインアップ'),
                                SizedBox(width: 8),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () => _onSignInWithAnonymousUser(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person_off_rounded),
                          SizedBox(width: 8),
                          Text('登録せず利用'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () => _onSignInGoogle(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.google,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Googleでログイン'),
                        ],
                      ),
                    ),
                    // GoogleSignInButton(
                    //     clientId:
                    //         '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com'),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'アカウント登録済の場合は',
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
                              MaterialPageRoute(
                                  builder: (context) => SignIn(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      )),
                            );
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                                height: 40,
                              ),
                              Icon(
                                Icons.login_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'サインイン',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(
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
