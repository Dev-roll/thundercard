import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:thundercard/api/settings/display_card_theme.dart';
import 'package:thundercard/home_page.dart';

import 'api/settings/app_theme.dart';
import 'auth_gate.dart';
import 'constants.dart';
import 'firebase_options.dart';

final appThemeProvider = ChangeNotifierProvider((ref) {
  return AppTheme();
});

final displayCardThemeProvider = ChangeNotifierProvider((ref) {
  return DisplayCardTheme();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    // EmailProvider(),
    GoogleProvider(
        clientId:
            '277870400251-aaolhktu6ilde08bn6cuhpi7q8adgr48.apps.googleusercontent.com'), // ... other providers
    TwitterProvider(
        apiKey: 'LXNJNGJDYjhZVTVZcFNxWEF1STk6MTpjaQ',
        apiSecretKey: 'YfaH718ntW78V8j-GrPf-N_fmUxTjxcKg5B-g9qJjymboUgYFK')
  ]);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey:
        'recaptcha-v3-site-key', // If you're building a web app.
  );
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
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thundercard_app',
          theme: ThemeData(
            useMaterial3: true,
            // fontFamily: '',
            colorSchemeSeed: lightDynamic?.primary ?? seedColor,
            brightness: Brightness.light,
            visualDensity: VisualDensity.standard,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            // fontFamily: '',
            colorSchemeSeed: darkDynamic?.primary ?? seedColor,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.standard,
            textTheme:
                GoogleFonts.interTextTheme(Theme.of(context).primaryTextTheme),
          ),
          themeMode: appTheme.currentAppTheme,
          locale: Locale('ja', 'JP'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja', 'JP'),
          ],
          home: SignInScreen(actions: [
            AuthStateChangeAction((context, state) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomePage(index: 0),
                ),
              );
            })
          ]),
          // home: AuthGate(),
        );
      },
    );
  }
}
