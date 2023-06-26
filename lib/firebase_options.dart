// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCXR9l0CiInxpTqvQiZs4CSIEKslcionus',
    appId: '1:277870400251:web:ca267c99a33bfeb25e565e',
    messagingSenderId: '277870400251',
    projectId: 'thundercard-test',
    authDomain: 'thundercard-test.firebaseapp.com',
    databaseURL:
        'https://thundercard-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'thundercard-test.appspot.com',
    measurementId: 'G-MNVXSEFK9W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBs7lQdIATKnpZ1MqLKhAbCnYA2Re1G68o',
    appId: '1:277870400251:android:a556001c2bed8de55e565e',
    messagingSenderId: '277870400251',
    projectId: 'thundercard-test',
    databaseURL:
        'https://thundercard-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'thundercard-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBo4ki_DZqi1bs_5UPHMaU5WfBYcAQTMZc',
    appId: '1:277870400251:ios:5084db0eac4a47bb5e565e',
    messagingSenderId: '277870400251',
    projectId: 'thundercard-test',
    databaseURL:
        'https://thundercard-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'thundercard-test.appspot.com',
    androidClientId:
        '277870400251-3ggi3hqj28s5ulrq1mrr6ncohq1kfkap.apps.googleusercontent.com',
    iosClientId:
        '277870400251-vgch323tnegebpcis8f0sddfldstnr38.apps.googleusercontent.com',
    iosBundleId: 'app.web.thundercard221115',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBo4ki_DZqi1bs_5UPHMaU5WfBYcAQTMZc',
    appId: '1:277870400251:ios:73d921a6f5689ae15e565e',
    messagingSenderId: '277870400251',
    projectId: 'thundercard-test',
    databaseURL:
        'https://thundercard-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'thundercard-test.appspot.com',
    androidClientId:
        '277870400251-3ggi3hqj28s5ulrq1mrr6ncohq1kfkap.apps.googleusercontent.com',
    iosClientId:
        '277870400251-cdjer3h8fea10ahaa26402dt8he7ere4.apps.googleusercontent.com',
    iosBundleId: 'app.web.thundercard',
  );
}
