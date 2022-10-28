import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thundercard/auth_gate.dart';

import 'home_page.dart';
import 'sign_in.dart';

class LinkAuth extends StatefulWidget {
  const LinkAuth({Key? key}) : super(key: key);

  @override
  State<LinkAuth> createState() => _LinkAuthState();
}

class _LinkAuthState extends State<LinkAuth> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  String passwordCheck = '';
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();

  void googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      // accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'サインアップ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Icon(
                      Icons.person_add_alt,
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
                            controller: _emailController,
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
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: hidePassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
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
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: hidePassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock),
                              labelText: 'パスワード（確認用）',
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
                                passwordCheck = value;
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
                            onPressed: !_emailController.text.contains('@') ||
                                    _passwordController.text.length < 8 ||
                                    passwordCheck.length < 8 ||
                                    _passwordController.text != passwordCheck
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      // サインアップの処理を書く
                                      () async {
                                        // Google Sign-in
                                        // final credential =
                                        //     GoogleAuthProvider.credential(idToken: idToken);

                                        // Email and password sign-in
                                        final credential =
                                            EmailAuthProvider.credential(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                        try {
                                          final userCredential =
                                              await FirebaseAuth
                                                  .instance.currentUser
                                                  ?.linkWithCredential(
                                                      credential);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthGate()),
                                          );
                                        } on FirebaseAuthException catch (e) {
                                          switch (e.code) {
                                            case "provider-already-linked":
                                              print(
                                                  "The provider has already been linked to the user.");
                                              break;
                                            case "invalid-credential":
                                              print(
                                                  "The provider's credential is not valid.");
                                              break;
                                            case "credential-already-in-use":
                                              print(
                                                  "The account corresponding to the credential already exists, "
                                                  "or is already linked to a Firebase User.");
                                              break;
                                            // See the API reference for the full list of error codes.
                                            default:
                                              print("Unknown error.");
                                          }
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
                            child: const Text('サインアップ'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => googleSignIn(),
                        child: Text('Googleでログイン'),
                      ),
                    ),
                    // GoogleSignInButton(
                    //     clientId:
                    //         '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com'),
                    SizedBox(
                      height: 32,
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
