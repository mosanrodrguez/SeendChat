import 'package:flutter/material.dart';
import 'colors.dart';

class SeendTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: SeendColors.primary,
    scaffoldBackgroundColor: SeendColors.background,
    fontFamily: 'Arial',
    appBarTheme: const AppBarTheme(backgroundColor: SeendColors.primary, foregroundColor: Colors.white, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: SeendColors.primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
    inputDecorationTheme: const InputDecorationTheme(border: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.border)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.border)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.primary, width: 2))),
    cardTheme: const CardTheme(elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: SeendColors.textPrimary), bodyLarge: TextStyle(fontSize: 14, color: SeendColors.textPrimary), bodyMedium: TextStyle(fontSize: 12, color: SeendColors.textSecondary)),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: SeendColors.primary,
    scaffoldBackgroundColor: SeendColors.darkBackground,
    fontFamily: 'Arial',
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1A1A1A), foregroundColor: Colors.white, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: SeendColors.primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
    inputDecorationTheme: const InputDecorationTheme(border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF444444))), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF444444))), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.primary, width: 2))),
    cardTheme: const CardTheme(elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: SeendColors.textDarkPrimary), bodyLarge: TextStyle(fontSize: 14, color: SeendColors.textDarkPrimary), bodyMedium: TextStyle(fontSize: 12, color: SeendColors.textDarkSecondary)),
  );
}
