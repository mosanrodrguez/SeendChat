import 'package:flutter/material.dart';
import 'colors.dart';

class SeendTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: SeendColors.primary,
    scaffoldBackgroundColor: SeendColors.background,
    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: SeendColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SeendColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: SeendColors.primary,
        side: const BorderSide(color: SeendColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: false,
      border: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.border)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.border)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.primary, width: 2)),
    ),

    cardTheme: const CardThemeData(elevation: 0, shadowColor: Colors.transparent),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: SeendColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: SeendColors.primary,
      unselectedItemColor: SeendColors.textSecondary,
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: SeendColors.textPrimary),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: SeendColors.textPrimary),
      bodyLarge: TextStyle(fontSize: 14, color: SeendColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 12, color: SeendColors.textSecondary),
    ),

    colorScheme: const ColorScheme.light(
      primary: SeendColors.primary,
      surface: SeendColors.background,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: SeendColors.primary,
    scaffoldBackgroundColor: const Color(0xFF121212),
    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SeendColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: SeendColors.primary,
        side: const BorderSide(color: SeendColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: false,
      border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF444444))),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF444444))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: SeendColors.primary, width: 2)),
    ),

    cardTheme: const CardThemeData(elevation: 0, shadowColor: Colors.transparent),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: SeendColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: SeendColors.primary,
      unselectedItemColor: SeendColors.textSecondary,
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(fontSize: 12, color: Color(0xFF999999)),
    ),

    colorScheme: const ColorScheme.dark(
      primary: SeendColors.primary,
      surface: Color(0xFF121212),
    ),
  );
}
