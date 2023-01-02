import 'package:firebase_auth/firebase_auth.dart';

String? getUid() {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    return currentUser.uid;
  } else {
    return null;
  }
}
