import 'package:flutter/material.dart';

class GymAppTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: const Color(0xFFFFB300), // Amarillo dorado intenso
      accentColor: const Color(0xFFFF6600), // Naranja intenso
      backgroundColor: const Color(0xFF332200), // Marrón oscuro
      scaffoldBackgroundColor:
          const Color(0xFF332200), // Fondo de la aplicación
      appBarTheme: AppBarTheme(
        color: const Color(0xFF332200), // Color de fondo del AppBar
        elevation: 0, // Sin sombra en el AppBar
        centerTitle: true,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white, // Color de texto del AppBar
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF442200), // Color de fondo de las cards
        elevation: 4, // Elevación de las cards
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Bordes redondeados de las cards
        ),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.white, // Texto principal en blanco
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: TextStyle(
          color: Colors.white, // Texto secundario en blanco
          fontSize: 16,
        ),
      ),
    );
  }
}
