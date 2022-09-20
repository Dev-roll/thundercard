import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thundercard/api/firebase_auth.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/auth_gate.dart';
import 'package:thundercard/thundercard.dart';
import 'package:thundercard/list.dart';
import 'package:thundercard/notifications.dart';
import 'package:thundercard/account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff1e2b2f),
        // systemNavigationBarIconBrightness: ThemeData(),
        statusBarColor: Color(0x00000000)),
    // SystemUiOverlayStyle.dark,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      // theme: ThemeData(
      //   useMaterial3: true,
      //   fontFamily: '',
      //   colorSchemeSeed: seedColor,
      //   visualDensity: VisualDensity.standard,
      //   brightness: Brightness.light,
      // ),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: '',
        colorSchemeSeed: seedColor,
        visualDensity: VisualDensity.standard,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        visualDensity: VisualDensity.standard,
        brightness: Brightness.dark,
      ),
      locale: Locale('ja', 'JP'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
      // home: const MyHomePage(title: 'Thundercard'),
      home: const AuthGate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  final String? uid = getUid();

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
            selectedIcon: Icon(
              Icons.contact_mail,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.contact_mail_outlined,
              color: seedColorLightA,
            ),
            label: 'Thundercard',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.ballot_rounded,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.ballot_outlined,
              color: seedColorLightA,
            ),
            label: 'List',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.notifications_rounded,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.notifications_none_rounded,
              color: seedColorLightA,
            ),
            label: 'Notifications',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.account_circle_rounded,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.account_circle_outlined,
              color: seedColorLightA,
            ),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        Thundercard(),
        List(),
        // List(uid: uid),
        Notifications(),
        Account(),
      ][currentPageIndex],
    );
  }
}
