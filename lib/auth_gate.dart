import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import 'api/current_brightness.dart';
import 'api/current_brightness_reverse.dart';
import 'widgets/custom_progress_indicator.dart';
import 'account_registration.dart';
import 'home_page.dart';

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        statusBarIconBrightness:
            currentBrightness(Theme.of(context).colorScheme),
        statusBarBrightness:
            currentBrightnessReverse(Theme.of(context).colorScheme),
        statusBarColor: Colors.transparent,
      ),
    );
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // return AccountRegistration();
        if (!snapshot.hasData) {
          return const SignInScreen(providerConfigs: [
            EmailProviderConfiguration(),
            GoogleProviderConfiguration(
                clientId:
                    '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com')
          ]);
        }
        return FutureBuilder(
            future: users.doc(snapshot.data?.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            });
      },
    );
  }
}
