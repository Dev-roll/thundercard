import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:thundercard/ui/screen/auth_gate.dart';

// import 'package:flutterfire_ui/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  bool hidePasswordCheck = true;
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> googleSignIn() async {
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
      await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential)
          .then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AuthGate()),
        );
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'provider-already-linked':
          Logger().d('The provider has already been linked to the user.');
          break;
        case 'invalid-credential':
          Logger().d('The provider\'s credential is not valid.');
          break;
        case 'credential-already-in-use':
          Logger()
              .d('The account corresponding to the credential already exists, '
                  'or is already linked to a Firebase User.');
          break;
        // See the API reference for the full list of error codes.
        default:
          Logger().d('Unknown error.');
      }
    }
  }

  // Future<void> _onSignInWithApple(User? user) async {
  //   try {
  //     // AuthorizationCredentialAppleIDのインスタンスを取得
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     // OAthCredentialのインスタンスを作成
  //     OAuthProvider oauthProvider = OAuthProvider('apple.com');
  //     final credential = oauthProvider.credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //     );

  //     if (user != null && user.isAnonymous) {
  //       await user.linkWithCredential(credential);
  //       Navigator.of(context).pop();
  //     } else {
  //       await FirebaseAuth.instance.signInWithCredential(credential);

  //       if (Navigator.of(context).canPop()) {
  //         Navigator.of(context).pop();
  //       } else {
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => AuthGate()),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     await showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text('エラー'),
  //             content: Text(e.toString()),
  //           );
  //         });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      24 + MediaQuery.of(context).padding.top,
                      24,
                      24 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'サインアップ',
                          // '認証方法の追加',
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
                              AutofillGroup(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: true,
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      onFieldSubmitted: (value) {
                                        if (_emailController.text
                                                .contains('@') &&
                                            _passwordController.text.length >=
                                                8 &&
                                            _passwordController.text ==
                                                passwordCheck &&
                                            formKey.currentState!.validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          try {
                                            final credential =
                                                EmailAuthProvider.credential(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            );
                                            FirebaseAuth.instance.currentUser
                                                ?.linkWithCredential(
                                              credential,
                                            );
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthGate(),
                                              ),
                                            );
                                          } on FirebaseAuthException catch (e) {
                                            switch (e.code) {
                                              case 'provider-already-linked':
                                                Logger().d(
                                                  'The provider has already been linked to the user.',
                                                );
                                                break;
                                              case 'invalid-credential':
                                                Logger().d(
                                                  'The provider\'s credential is not valid.',
                                                );
                                                break;
                                              case 'credential-already-in-use':
                                                Logger().d(
                                                    'The account corresponding to the credential already exists, '
                                                    'or is already linked to a Firebase User.');
                                                break;
                                              // See the API reference for the full list of error codes.
                                              default:
                                                Logger().d('Unknown error.');
                                            }
                                          }
                                        }
                                      },
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
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autocorrect: true,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
                                      onFieldSubmitted: (value) {
                                        if (_emailController.text
                                                .contains('@') &&
                                            _passwordController.text.length >=
                                                8 &&
                                            _passwordController.text ==
                                                passwordCheck &&
                                            formKey.currentState!.validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          try {
                                            final credential =
                                                EmailAuthProvider.credential(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            );
                                            FirebaseAuth.instance.currentUser
                                                ?.linkWithCredential(
                                              credential,
                                            );
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthGate(),
                                              ),
                                            );
                                          } on FirebaseAuthException catch (e) {
                                            switch (e.code) {
                                              case 'provider-already-linked':
                                                Logger().d(
                                                  'The provider has already been linked to the user.',
                                                );
                                                break;
                                              case 'invalid-credential':
                                                Logger().d(
                                                  'The provider\'s credential is not valid.',
                                                );
                                                break;
                                              case 'credential-already-in-use':
                                                Logger().d(
                                                    'The account corresponding to the credential already exists, '
                                                    'or is already linked to a Firebase User.');
                                                break;
                                              // See the API reference for the full list of error codes.
                                              default:
                                                Logger().d('Unknown error.');
                                            }
                                          }
                                        }
                                      },
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
                                      obscureText: hidePasswordCheck,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autocorrect: true,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
                                      onFieldSubmitted: (value) {
                                        if (_emailController.text
                                                .contains('@') &&
                                            _passwordController.text.length >=
                                                8 &&
                                            _passwordController.text ==
                                                passwordCheck &&
                                            formKey.currentState!.validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          try {
                                            final credential =
                                                EmailAuthProvider.credential(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            );
                                            FirebaseAuth.instance.currentUser
                                                ?.linkWithCredential(
                                              credential,
                                            );
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthGate(),
                                              ),
                                            );
                                          } on FirebaseAuthException catch (e) {
                                            switch (e.code) {
                                              case 'provider-already-linked':
                                                Logger().d(
                                                  'The provider has already been linked to the user.',
                                                );
                                                break;
                                              case 'invalid-credential':
                                                Logger().d(
                                                  'The provider\'s credential is not valid.',
                                                );
                                                break;
                                              case 'credential-already-in-use':
                                                Logger().d(
                                                    'The account corresponding to the credential already exists, '
                                                    'or is already linked to a Firebase User.');
                                                break;
                                              // See the API reference for the full list of error codes.
                                              default:
                                                Logger().d('Unknown error.');
                                            }
                                          }
                                        }
                                      },
                                      textInputAction: TextInputAction.go,
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.lock_rounded),
                                        labelText: 'パスワード（確認用）',
                                        suffixIcon: IconButton(
                                          splashRadius: 20,
                                          icon: Icon(
                                            hidePasswordCheck
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              hidePasswordCheck =
                                                  !hidePasswordCheck;
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
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      onPressed: !_emailController.text
                                                  .contains('@') ||
                                              _passwordController.text.length <
                                                  8 ||
                                              passwordCheck.length < 8 ||
                                              _passwordController.text !=
                                                  passwordCheck
                                          ? null
                                          : () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                try {
                                                  final credential =
                                                      EmailAuthProvider
                                                          .credential(
                                                    email:
                                                        _emailController.text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                  );
                                                  FirebaseAuth
                                                      .instance.currentUser
                                                      ?.linkWithCredential(
                                                    credential,
                                                  );
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AuthGate(),
                                                    ),
                                                  );
                                                } on FirebaseAuthException catch (e) {
                                                  switch (e.code) {
                                                    case 'provider-already-linked':
                                                      Logger().d(
                                                        'The provider has already been linked to the user.',
                                                      );
                                                      break;
                                                    case 'invalid-credential':
                                                      Logger().d(
                                                        'The provider\'s credential is not valid.',
                                                      );
                                                      break;
                                                    case 'credential-already-in-use':
                                                      Logger().d(
                                                          'The account corresponding to the credential already exists, '
                                                          'or is already linked to a Firebase User.');
                                                      break;
                                                    // See the API reference for the full list of error codes.
                                                    default:
                                                      Logger().d(
                                                        'Unknown error.',
                                                      );
                                                  }
                                                }
                                              }
                                            },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 8),
                                          Icon(Icons.person_add_alt),
                                          SizedBox(width: 8),
                                          Text('サインアップ'),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        if (!kIsWeb && Platform.isAndroid)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () => googleSignIn(),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.google,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('Googleでサインアップ'),
                              ],
                            ),
                          ),
                        if (kIsWeb)
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 400,
                            ),
                            child: const GoogleSignInButton(
                              clientId:
                                  '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com',
                              loadingIndicator: CircularProgressIndicator(),
                            ),
                          ),
                        // if (!kIsWeb && Platform.isIOS)
                        //   const GoogleSignInButton(
                        //       clientId:
                        //           '277870400251-7s65salaj527fnrhcr1ls4jq2k7le21f.apps.googleusercontent.com'),
                        // if (!kIsWeb && Platform.isMacOS)
                        //   const GoogleSignInButton(
                        //       clientId:
                        //           '277870400251-g3q7bmmb90ptq3krepjv1bhngm687icd.apps.googleusercontent.com'),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        // if (!kIsWeb && (Platform.isIOS || Platform.isMacOS))
                        //   SignInButton(
                        //     Buttons.Apple,
                        //     onPressed: () {
                        //       _onSignInWithApple(user);
                        //     },
                        //   ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 32,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
