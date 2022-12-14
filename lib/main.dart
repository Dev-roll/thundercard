// ignore_for_file: prefer_const_constructors

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:thundercard/md_page.dart';
import 'package:thundercard/widgets/md/about_app.dart';

import 'api/settings/custom_theme.dart';
import 'auth_gate.dart';
import 'constants.dart';
import 'firebase_options.dart';

final customThemeProvider = ChangeNotifierProvider((ref) {
  return CustomTheme();
});

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
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey:
        'recaptcha-v3-site-key', // If you're building a web app.
    // androidDebugProvider: true,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTheme = ref.watch(customThemeProvider);
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thundercard',
          theme: ThemeData(
            useMaterial3: true,
            // fontFamily: '',
            colorSchemeSeed: lightDynamic?.harmonized().primary ?? seedColor,
            brightness: Brightness.light,
            visualDensity: VisualDensity.standard,
            textTheme: kIsWeb
                ? GoogleFonts.zenKakuGothicNewTextTheme(
                    Theme.of(context).textTheme)
                : GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            // fontFamily: '',
            colorSchemeSeed: darkDynamic?.harmonized().primary ?? seedColor,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.standard,
            textTheme: kIsWeb
                ? GoogleFonts.zenKakuGothicNewTextTheme(
                    Theme.of(context).primaryTextTheme)
                : GoogleFonts.interTextTheme(
                    Theme.of(context).primaryTextTheme),
          ),
          themeMode: customTheme.currentAppTheme,
          locale: Locale('ja', 'JP'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja', 'JP'),
          ],
          // home: AuthGate(),
          home: MdPage(title: Text('test'), data: aboutAppData),
        );
      },
    );
  }
}
