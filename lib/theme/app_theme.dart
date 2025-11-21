import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const primary = Color(0xFFBB86FC);
  static const gold = Color(0xFFF2B300);
  static const accent = Color(0xFFF2B300); // dorado suave
  static const bg = Color(0xFF141218);
  static const cardDark = Color(0xFF1E1B22);

  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    fontFamily: "Montserrat",
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
