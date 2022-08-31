// import 'package:flutter/material.dart';
// import 'package:thundercard/constants.dart';
// import 'package:thundercard/login.dart';
// import 'package:thundercard/thundercard.dart';
// import 'package:thundercard/list.dart';
// import 'package:thundercard/notifications.dart';
// import 'package:thundercard/account.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Thundercard_app',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: seedColor,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: seedColor,
//         brightness: Brightness.dark,
//       ),
//       // home: const MyHomePage(title: 'Thundercard'),
//       home: const Login(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int currentPageIndex = 0;
//   String userName = 'Sam';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             currentPageIndex = index;
//           });
//         },
//         selectedIndex: currentPageIndex,
//         destinations: const <Widget>[
//           NavigationDestination(
//             selectedIcon: Icon(Icons.contact_mail),
//             icon: Icon(Icons.contact_mail_outlined),
//             label: 'Tundercard',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.view_list_outlined),
//             icon: Icon(Icons.list_alt_rounded),
//             label: 'List',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.notifications_rounded),
//             icon: Icon(Icons.notifications_none_rounded),
//             label: 'Notifications',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.account_circle_rounded),
//             icon: Icon(Icons.account_circle_outlined),
//             label: 'Account',
//           ),
//         ],
//       ),
//       body: <Widget>[
//         Thundercard(name: userName),
//         List(),
//         Notifications(),
//         Account(),
//       ][currentPageIndex],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// MyApp,MyHomePageはデフォルトから変更がないため省略
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          // ボタンを押した時のイベント
          onPressed: () async {
            FirebaseFirestore.instance
                .doc('autoCollection1/autoDocument1')
                .set({'autofield': "abc"});
            // FirebaseFirestore.instance
            //     .collection('autoCollection2')
            //     .add({'autofield': "xyz"});
            FirebaseFirestore.instance
                .collection('flutterDataCollection')
                .doc('flutterDataDocument')
                .get()
                .then((ref) {
              print(ref.get("mydata"));
            });
          },
          child: const Text(
            '実行',
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }
}
