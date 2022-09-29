import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth_gate.dart';
import 'constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //       // systemNavigationBarColor: Color(0xff1e2b2f),
  //       // systemNavigationBarIconBrightness: ThemeData(),
  //       // statusBarColor: Color(0x00000000),
  //       ),
  //   // SystemUiOverlayStyle.dark,
  // );
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
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thundercard_app',
          // theme: ThemeData(
          //   useMaterial3: true,
          //   fontFamily: '',
          //   colorSchemeSeed: seedColor,
          // colorSchemeSeed: lightDynamic?.primary ?? seedColor,
          //   visualDensity: VisualDensity.standard,
          //   brightness: Brightness.light,
          // ),
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: '',
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                    brightness: Brightness.light, seedColor: seedColor),
            visualDensity: VisualDensity.standard,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: '',
            colorScheme: darkDynamic ??
                ColorScheme.fromSeed(
                    brightness: Brightness.dark, seedColor: seedColor),
            visualDensity: VisualDensity.standard,
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
      },
    );
  }
}
