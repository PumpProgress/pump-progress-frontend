import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/config/constants/fonts.dart';

final theme = ThemeData.from(
  textTheme: retroMinimalTextTheme,
  colorScheme: const ColorScheme(
    primary: PPColors.amethyst300,
    onPrimary: Colors.white,
    secondary: PPColors.coral300,
    onSecondary: PPColors.white,
    error: PPColors.coral300,
    onError: Colors.white,
    brightness: Brightness.dark,
    surface: PPColors.neutral500,
    onSurface: Colors.white,
  ),
  useMaterial3: true,
).copyWith(
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
    },
  ),
);

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child; // No animation
  }
}

// {
//   "0": 0,
//   "0.5": 2,
//   "1": 4,
//   "1.5": 6,
//   "2": 8,
//   "2.5": 10,
//   "3": 12,
//   "3.5": 14,
//   "4": 16,
//   "5": 20,
//   "6": 24,
//   "7": 28,
//   "8": 32,
//   "9": 36,
//   "10": 40,
//   "11": 44,
//   "12": 48,
//   "14": 56,
//   "16": 64,
//   "20": 80,
//   "24": 96,
//   "28": 112,
//   "32": 128,
//   "36": 144,
//   "40": 160,
//   "44": 176,
//   "48": 192,
//   "52": 208,
//   "56": 224,
//   "60": 240,
//   "64": 256,
//   "72": 288,
//   "80": 320,
//   "96": 384
// }
