import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.darkBackground,
        primary: AppColors.accentNeon,
        outline: Colors.white10,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontFamily: 'RobotoMono'),
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        surface: AppColors.lightBackground,
        primary: AppColors.accentBlue,
        outline: Colors.black12,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontFamily: 'RobotoMono'),
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
    );
  }
}