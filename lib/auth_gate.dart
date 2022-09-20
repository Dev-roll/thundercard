import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/account_registration.dart';
import 'package:thundercard/home_page.dart';
import 'package:flutterfire_ui/auth.dart';

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
              return const Text('loading');
            });
      },
    );
  }
}
