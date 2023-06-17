import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';

final theme = ThemeData.from(
  colorScheme: const ColorScheme(
    primary: PumpProgressColors.amethyst,
    onPrimary: PumpProgressColors.black,
    secondary: PumpProgressColors.coral,
    onSecondary: PumpProgressColors.white,
    error: PumpProgressColors.coral,
    onError: PumpProgressColors.black,
    brightness: Brightness.dark,
    background: PumpProgressColors.black,
    onBackground: PumpProgressColors.silver,
    surface: PumpProgressColors.black,
    onSurface: PumpProgressColors.amethyst,
  ),
  useMaterial3: true,
);
