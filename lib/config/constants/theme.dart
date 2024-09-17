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
);
