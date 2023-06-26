import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thundercard/views/pages/auth_gate.dart';
import 'package:thundercard/views/pages/md_page.dart';
import 'package:thundercard/views/pages/sign_in.dart';
import 'package:thundercard/views/widgets/md/privacy_policy.dart';
import 'package:thundercard/views/widgets/md/terms_of_use.dart';

// import 'package:flutterfire_ui/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final TextEditingController _emailController =
      TextEditingController(text: widget.email);
  late final TextEditingController _passwordController =
      TextEditingController();
  String passwordCheck = '';
  bool hidePassword = true;
  bool hidePasswordCheck = true;
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  Future _onSignInWithAnonymousUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInAnonymously();
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
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

      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
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
        await user.linkWithCredential(credential);
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
        }
      }
    } catch (e) {
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
                                            FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            )
                                                .then((value) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AuthGate(),
                                                ),
                                              );
                                            });
                                          } catch (e) {
                                            debugPrint('$e');
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
                                            FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            )
                                                .then((value) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AuthGate(),
                                                ),
                                              );
                                            });
                                          } catch (e) {
                                            debugPrint('$e');
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
                                            FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            )
                                                .then((value) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AuthGate(),
                                                ),
                                              );
                                            });
                                          } catch (e) {
                                            debugPrint('$e');
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
                                                  FirebaseAuth.instance
                                                      .createUserWithEmailAndPassword(
                                                    email:
                                                        _emailController.text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                  )
                                                      .then((value) {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AuthGate(),
                                                      ),
                                                    );
                                                  });
                                                } catch (e) {
                                                  debugPrint('$e');
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
                                    )
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
                                    Icons.login_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'サインイン',
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
