import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thundercard/ui/component/md/privacy_policy.dart';
import 'package:thundercard/ui/component/md/terms_of_use.dart';
import 'package:thundercard/ui/screen/auth_gate.dart';
import 'package:thundercard/ui/screen/md_page.dart';
import 'package:thundercard/ui/screen/sign_up.dart';

// import 'package:flutterfire_ui/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, this.email}) : super(key: key);
  final String? email;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final TextEditingController _emailController =
      TextEditingController(text: widget.email ?? '');
  late final TextEditingController _passwordController =
      TextEditingController();
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  Future _onSignInWithAnonymousUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
      await firebaseAuth.signInAnonymously();
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
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );

      final googleLogin = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );

      GoogleSignInAccount? signinAccount = await googleLogin.signIn();
      if (signinAccount == null) return;

      GoogleSignInAuthentication auth = await signinAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
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

  Future<void> _onSignInWithApple(User? user) async {
    try {
      // AuthorizationCredentialAppleIDのインスタンスを取得
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // OAthCredentialのインスタンスを作成
      OAuthProvider oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      if (user != null && user.isAnonymous) {
        if (!mounted) return;
        Navigator.of(context).pop();
        await user.linkWithCredential(credential);
      } else {
        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
        }

        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      final mounted = context.mounted;
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('エラー'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                          'サインイン',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Icon(
                          Icons.login_rounded,
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
                                        AutofillHints.email,
                                      ],
                                      onFieldSubmitted: (value) {
                                        if (_emailController.text
                                                .contains('@') &&
                                            _passwordController.text.length >=
                                                8 &&
                                            formKey.currentState!.validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          try {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthGate(),
                                              ),
                                            );
                                            FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                )
                                                .then((value) {});
                                          } catch (e) {
                                            Logger().e('$e');
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
                                      autofillHints: const [
                                        AutofillHints.password,
                                      ],
                                      onFieldSubmitted: (value) {
                                        if (_emailController.text
                                                .contains('@') &&
                                            _passwordController.text.length >=
                                                8 &&
                                            formKey.currentState!.validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          try {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthGate(),
                                              ),
                                            );
                                            FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                )
                                                .then((value) {});
                                          } catch (e) {
                                            Logger().e('$e');
                                          }
                                        }
                                      },
                                      textInputAction: TextInputAction.go,
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
                                                  8
                                          ? null
                                          : () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                try {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AuthGate(),
                                                    ),
                                                  );
                                                  FirebaseAuth.instance
                                                      .signInWithEmailAndPassword(
                                                        email: _emailController
                                                            .text,
                                                        password:
                                                            _passwordController
                                                                .text,
                                                      )
                                                      .then((value) {});
                                                } catch (e) {
                                                  Logger().e('$e');
                                                }
                                              }
                                            },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 8),
                                          Icon(Icons.login_rounded),
                                          SizedBox(width: 8),
                                          Text('サインイン'),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_off_rounded),
                              SizedBox(width: 8),
                              Text('登録せず利用'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (!kIsWeb && Platform.isAndroid)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () => _onSignInGoogle(),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.google,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('Googleでログイン'),
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
                              loadingIndicator: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                              ),
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
                        const SizedBox(
                          height: 8,
                        ),
                        if (!kIsWeb && (Platform.isIOS || Platform.isMacOS))
                          SignInButton(
                            Buttons.Apple,
                            onPressed: () {
                              _onSignInWithApple(user);
                            },
                          ),
                        const SizedBox(
                          height: 20,
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
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(
                                      email: _emailController.text,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 8,
                                    height: 40,
                                  ),
                                  Icon(
                                    Icons.person_add_alt,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'サインアップ',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(height: 1.6),
                            children: [
                              TextSpan(
                                text: 'このサービスのご利用を開始することで、',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              TextSpan(
                                text: 'プライバシーポリシー',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const MdPage(
                                            title: Text('プライバシーポリシー'),
                                            data: privacyPolicyData,
                                          );
                                        },
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: 'および',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              TextSpan(
                                text: '利用規約',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const MdPage(
                                            title: Text('利用規約'),
                                            data: termsOfUseData,
                                          );
                                        },
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: 'に同意したものとみなします。',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ],
                          ),
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
