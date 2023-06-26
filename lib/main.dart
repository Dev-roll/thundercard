import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thundercard/app.dart';
import 'package:thundercard/data/di/shared_preferences_provider.dart';
import 'package:thundercard/firebase_options.dart';
import 'package:thundercard/providers/custom_theme.dart';

final customThemeProvider = ChangeNotifierProvider((ref) {
  return CustomTheme();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey:
        'recaptcha-v3-site-key', // If you're building a web app.
    // androidDebugProvider: true,
  );
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        )
      ],

      child: const ThundercardApp(),
    ),
  );
}
