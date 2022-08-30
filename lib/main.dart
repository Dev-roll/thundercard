import 'package:flutter/material.dart';
import 'package:thundercard/Thundercard.dart';
import 'package:thundercard/List.dart';
import 'package:thundercard/Notifications.dart';
import 'package:thundercard/Account.dart';

const SeedColor = Color(0xFF11B4D8);

void main() {
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
        colorSchemeSeed: SeedColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: SeedColor,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Thundercard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  // _MyHomePageState createState() => _MyHomePageState();
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

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
        // Container(
        //   color: Colors.red,
        //   alignment: Alignment.center,
        //   child: const Text('Page 1'),
        //   child: TestPage1(),
        // ),
        Thundercard(),
        List(),
        Notifications(),
        Account(),
      ][currentPageIndex],
    );
  }
}
