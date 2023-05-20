import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_options.dart';
import 'providers/custom_theme.dart';
import 'utils/constants.dart';
import 'views/pages/auth_gate.dart';

final customThemeProvider = ChangeNotifierProvider((ref) {
  return CustomTheme();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            colorScheme: lightDynamic?.harmonized() ??
                ColorScheme.fromSeed(seedColor: seedColor).harmonized(),
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
            colorScheme: darkDynamic?.harmonized() ??
                ColorScheme.fromSeed(seedColor: seedColor).harmonized(),
            brightness: Brightness.dark,
            visualDensity: VisualDensity.standard,
            textTheme: kIsWeb
                ? GoogleFonts.zenKakuGothicNewTextTheme(
                    Theme.of(context).primaryTextTheme)
                : GoogleFonts.interTextTheme(
                    Theme.of(context).primaryTextTheme),
          ),
          themeMode: customTheme.currentAppTheme,
          locale: const Locale('ja', 'JP'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja', 'JP'),
          ],
          home: AuthGate(),
        );
      },
    );
  }
}
