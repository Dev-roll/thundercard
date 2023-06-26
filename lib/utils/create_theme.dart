import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thundercard/utils/constants.dart';

bool isApplePlatform() {
  return !kIsWeb && (Platform.isIOS || Platform.isMacOS);
}

bool isAndroidPlatform() {
  return !kIsWeb && Platform.isAndroid;
}

ThemeData createTheme(
  ColorScheme? dynamicColor,
  Brightness brightness,
  BuildContext context,
) {
  bool isApple = isApplePlatform();
  bool isAndroid = isAndroidPlatform();

  var colorScheme = dynamicColor?.harmonized() ??
      ColorScheme.fromSeed(seedColor: seedColor).harmonized();
  colorScheme = colorScheme.copyWith(brightness: brightness);
  return ThemeData(
    useMaterial3: true,
    colorScheme: isAndroid ? colorScheme : null,
    colorSchemeSeed: isAndroid ? null : colorScheme.primary,
    brightness: brightness,
    visualDensity: VisualDensity.standard,
    textTheme: kIsWeb && brightness == Brightness.light
        ? GoogleFonts.zenKakuGothicNewTextTheme(Theme.of(context).textTheme)
        : kIsWeb && brightness == Brightness.dark
            ? GoogleFonts.zenKakuGothicNewTextTheme(
                Theme.of(context).primaryTextTheme,
              )
            : !isApple && brightness == Brightness.light
                ? GoogleFonts.interTextTheme(Theme.of(context).textTheme)
                : !isApple && brightness == Brightness.dark
                    ? GoogleFonts.interTextTheme(
                        Theme.of(context).primaryTextTheme,
                      )
                    : null,
  );
}
