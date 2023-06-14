import 'package:flutter/material.dart';

class GymAppTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: const Color(0xFFFFB300), // Marrón oscuro
      scaffoldBackgroundColor:
          const Color(0xFF332200), // Fondo de la aplicación
      appBarTheme: const AppBarTheme(
        color: Color(0xFF332200), // Color de fondo del AppBar
        elevation: 0, // Sin sombra en el AppBar
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF442200), // Color de fondo de las cards
        elevation: 4, // Elevación de las cards
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Bordes redondeados de las cards
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white, // Texto principal en blanco
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.white, // Texto secundario en blanco
          fontSize: 16,
        ),
      ),
    );
  }
}
