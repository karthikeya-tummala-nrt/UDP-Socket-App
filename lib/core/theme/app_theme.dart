import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    const background = Color(0xFF0F172A);
    const surface = Color(0xFF1E293B);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: Colors.blueAccent,
        secondary: Colors.green,
        error: Colors.redAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
      ),
      useMaterial3: true,
    );
  }
}