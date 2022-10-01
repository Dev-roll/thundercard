import 'package:flutter/material.dart';

Brightness currentBrightness(ColorScheme colorScheme) {
  if (colorScheme.background.computeLuminance() < 0.5) {
    return Brightness.dark;
  }
  return Brightness.light;
}
