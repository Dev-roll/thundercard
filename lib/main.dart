import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/login.dart';
import 'package:thundercard/thundercard.dart';
import 'package:thundercard/list.dart';
import 'package:thundercard/notifications.dart';
import 'package:thundercard/account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thundercard_app',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark,
      ),
      // home: const MyHomePage(title: 'Thundercard'),
      home: const Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {Key? key, required this.title, required this.type, required this.data})
      : super(key: key);
  final String title;
  final String type;
  final String data;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  String userName = 'keigomichi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.contact_mail),
            icon: Icon(Icons.contact_mail_outlined),
            label: 'Tundercard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.view_list_outlined),
            icon: Icon(Icons.list_alt_rounded),
            label: 'List',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications_rounded),
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Notifications',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_rounded),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        Thundercard(name: widget.data),
        List(),
        Notifications(),
        Account(),
      ][currentPageIndex],
    );
  }
}
