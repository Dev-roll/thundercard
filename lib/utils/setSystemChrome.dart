import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'current_brightness.dart';
import 'current_brightness_reverse.dart';

void setSystemChrome(
  BuildContext context, {
  Color? navColor,
  Color? staColor,
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: navColor ??
          alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface,
          ),
      statusBarIconBrightness:
          currentBrightnessReverse(Theme.of(context).colorScheme),
      statusBarBrightness: currentBrightness(Theme.of(context).colorScheme),
      statusBarColor: staColor ?? Colors.transparent,
    ),
  );
}
