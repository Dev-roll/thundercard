import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
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
      home: AuthGate(),
    );
  }
}
