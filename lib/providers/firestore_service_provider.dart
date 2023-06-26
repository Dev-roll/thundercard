// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/services/firestore_service.dart';
import 'package:thundercard/utils/firebase_auth.dart';

// final firebaseAuthProvider =
//     Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// final authStateChangesProvider = StreamProvider.autoDispose<User?>(
//     (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final firestoreServiceProvider = Provider.autoDispose<FirestoreService?>((ref) {
  // final auth = ref.watch(authStateChangesProvider);
  final String? currentUid = getUid();
  if (currentUid != null) {
    return FirestoreService(uid: currentUid);
  }
  throw Exception('uid is null');

  // if (auth.currentUser.asData?.value?.uid != null) {
  //   return FirestoreService(uid: auth.asData!.value!.uid);
  // }

  // throw Exception('authStateChangesProvider is null');
  // return null;
});
