import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Custom Color Palette
  static const Color primaryColor = Color(0xFF77CED9); // main accent
  static const Color primaryColor2 = Color(0xFFFFD700); // secondary accent
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF001540);
  static const Color cardColor = Color(0xFF1E293B);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color accentColor = Color(0xFFF43F5E);
  static const Color green = Color(0xFF00FF48);
  static const Color red = Color(0xFFFF0000);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF9CA3AF);
  static const Color lightGrey = Color(0xFFE5E7EB);
  static const Color errorColor = Color(0xFFEF4444);

  // Primary Swatch (simplified to match primaryColor better)
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF77CED9,
    <int, Color>{
      50: Color(0xFFE0F7FA),
      100: Color(0xFFB2EBF2),
      200: Color(0xFF80DEEA),
      300: Color(0xFF4DD0E1),
      400: Color(0xFF26C6DA),
      500: Color(0xFF00BCD4),
      600: Color(0xFF00ACC1),
      700: Color(0xFF0097A7),
      800: Color(0xFF00838F),
      900: Color(0xFF006064),
    },
  );

  // LIGHT THEME
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: primarySwatch,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundLight,
        cardColor: backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundLight,
          foregroundColor: primaryColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );

  // DARK THEME
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: primarySwatch,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundDark,
        cardColor: cardColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundDark,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );
}
