import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/ui/component/error_message.dart';
import 'package:thundercard/ui/screen/account_editor.dart';
import 'package:thundercard/ui/screen/home_page.dart';
import 'package:thundercard/ui/screen/sign_in.dart';

class AuthGate extends ConsumerWidget {
  AuthGate({Key? key}) : super(key: key);
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignIn();
        }
        return FutureBuilder(
          future: users.doc(snapshot.data?.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const ErrorMessage(err: '問題が発生しました');
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return const AccountEditor(
                isRegistration: true,
                isUser: true,
              );
            }
            return HomePage();
          },
        );
      },
    );
  }
}
