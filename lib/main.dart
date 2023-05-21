import 'dart:io';

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
    ThemeData baseTheme(ColorScheme? dynamicColor, Brightness brightness,
        bool isAndroid, bool isApple, BuildContext context) {
      var colorScheme = dynamicColor?.harmonized() ??
          ColorScheme.fromSeed(seedColor: seedColor).harmonized();
      return ThemeData(
        useMaterial3: true,
        colorScheme: isAndroid ? colorScheme : null,
        colorSchemeSeed: isAndroid ? null : colorScheme.primary,
        brightness: brightness,
        visualDensity: VisualDensity.standard,
        textTheme: !isApple && brightness == Brightness.light
            ? GoogleFonts.interTextTheme(Theme.of(context).textTheme)
            : !isApple && brightness == Brightness.dark
                ? GoogleFonts.interTextTheme(Theme.of(context).primaryTextTheme)
                : null,
      );
    }

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        bool isApple = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
        bool isAndroid = !kIsWeb && Platform.isAndroid;

        ThemeData theme(ColorScheme? dynamicColor) {
          return baseTheme(
              dynamicColor, Brightness.light, isAndroid, isApple, context);
        }

        ThemeData darkTheme(ColorScheme? dynamicColor) {
          return baseTheme(
              dynamicColor, Brightness.dark, isAndroid, isApple, context);
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thundercard',
          theme: theme(lightDynamic),
          darkTheme: darkTheme(darkDynamic),
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
