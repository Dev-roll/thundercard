import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/account_registration.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'package:thundercard/home_page.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
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
                return const Text('Something went wrong');
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return AccountRegistration();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return HomePage();
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
