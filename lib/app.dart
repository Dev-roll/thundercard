import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/main.dart';
import 'package:thundercard/utils/create_theme.dart';
import 'package:thundercard/views/pages/auth_gate.dart';

class ThundercardApp extends ConsumerWidget {
  const ThundercardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTheme = ref.watch(customThemeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thundercard',
          theme: createTheme(lightDynamic, Brightness.light, context),
          darkTheme: createTheme(darkDynamic, Brightness.dark, context),
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
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
            ),
            child: AuthGate(),
          ),
        );
      },
    );
  }
}
