import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
// import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thundercard/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'firebase_options.dart';
import 'home_page.dart';
import 'sign_up.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: Row(
        children: [
          // MyCustomSideBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FirebaseUIActions(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (!state.user!.emailVerified) {
                    // Navigator.pushNamed(context, '/verify-email');
                  } else {
                    // Navigator.pushReplacementNamed(context, '/profile');
                  }
                }),
              ],
              child: LoginView(
                action: AuthAction.signUp,
                providers: FirebaseUIAuth.providersFor(
                  FirebaseAuth.instance.app,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class SignIn extends StatefulWidget {
//   const SignIn({Key? key, this.email, this.password}) : super(key: key);
//   final String? email;
//   final String? password;

//   @override
//   State<SignIn> createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   @override
//   Widget build(BuildContext) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // MyCustomSideBar(),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: FirebaseUIActions(
//               actions: [
//                 AuthStateChangeAction<SignedIn>((context, state) {
//                   if (!state.user!.emailVerified) {
//                     Navigator.pushNamed(context, '/verify-email');
//                   } else {
//                     Navigator.pushReplacementNamed(context, '/profile');
//                   }
//                 }),
//               ],
//               child: LoginView(
//                 action: AuthAction.signUp,
//                 providers: FirebaseUIAuth.providersFor(
//                   FirebaseAuth.instance.app,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
