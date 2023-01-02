import 'package:flutter/material.dart';

Brightness currentBrightnessReverse(ColorScheme colorScheme) {
  if (colorScheme.background.computeLuminance() < 0.5) {
    return Brightness.light;
  }
  return Brightness.dark;
}
