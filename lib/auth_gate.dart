import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thundercard/sign_in.dart';
import 'package:thundercard/sign_up.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import 'api/current_brightness.dart';
import 'api/current_brightness_reverse.dart';
import 'widgets/custom_progress_indicator.dart';
import 'account_registration.dart';
import 'home_page.dart';

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);
  CollectionReference users = FirebaseFirestore.instance.collection('users');
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

  // Future<void> _onSignInGoogle() async {
  //   try {
  //     final googleLogin = GoogleSignIn(scopes: [
  //       'email',
  //       'https://www.googleapis.com/auth/contacts.readonly',
  //     ]);

  //     GoogleSignInAccount? signinAccount = await googleLogin.signIn();
  //     if (signinAccount == null) return;

  //     GoogleSignInAuthentication auth = await signinAccount.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       idToken: auth.idToken,
  //       accessToken: auth.accessToken,
  //     );
  //     FirebaseAuth.instance.signInWithCredential(credential);

  //     // Navigator.of(context).pushReplacement(
  //     //     MaterialPageRoute(
  //     //       builder: (_) => PhotoListScreen(),
  //     //     )
  //     // );
  //   } catch (e) {
  //     // await showDialog(
  //     //     context: context,
  //     //     builder: (context) {
  //     //       return AlertDialog(
  //     //         title: Text('エラー'),
  //     //         content: Text(e.toString()),
  //     //       );
  //     //     }
  //     // );
  //   }
  // }

  // Future<void> _onLoginButtonPressedEvent() async {
  //   GoogleSignIn _googleSignIn = GoogleSignIn();
  //   try {
  //     GoogleSignInAccount? result = await _googleSignIn.signIn();

  //     final name = result!.displayName;
  //     final email = result.email;
  //     final password = result.id;

  //     debugPrint(result);
  //   } catch (error) {
  //     debugPrint(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        statusBarIconBrightness:
            currentBrightnessReverse(Theme.of(context).colorScheme),
        statusBarBrightness: currentBrightness(Theme.of(context).colorScheme),
        statusBarColor: Colors.transparent,
      ),
    );
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // return AccountRegistration();
        // if (true) {
        if (!snapshot.hasData) {
          return SignIn();
          return Scaffold(
            body: SafeArea(
              child: Form(
                // key: _formKey, //validation用
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //　~中略~

                        // ここから新規追加
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _onSignInWithAnonymousUser(),
                            child: Text('登録せず利用'),
                          ),
                        ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: () => _onLoginButtonPressedEvent(),
                        //     child: Text('Google'),
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: () => _onSignInGoogle(),
                        //     child: Text('Google'),
                        //   ),
                        // ),
                        SizedBox(height: 10),
                        GoogleSignInButton(
                            clientId:
                                '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com')
                        // ここまで新規追加
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          // return const SignInScreen(providerConfigs: [
          //   EmailProviderConfiguration(),
          //   GoogleProviderConfiguration(
          //       clientId:
          //           '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com')
          // ]);
        }
        return FutureBuilder(
          future: users.doc(snapshot.data?.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('問題が発生しました');
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return AccountRegistration();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return HomePage(
                index: 0,
              );
            }
            return const Scaffold(
              body: Center(
                child: CustomProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}
