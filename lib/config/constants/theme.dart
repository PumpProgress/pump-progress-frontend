import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

final theme = ThemeData.from(
  colorScheme: const ColorScheme(
    primary: PPColors.amethyst300,
    onPrimary: PPColors.neutral500,
    secondary: PPColors.coral300,
    onSecondary: PPColors.white,
    error: PPColors.coral300,
    onError: PPColors.neutral500,
    brightness: Brightness.dark,
    surface: PPColors.neutral500,
    onSurface: PPColors.amethyst300,
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
