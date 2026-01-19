import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Updated Custom Color Palette
  static const Color primaryColor = Color(0xFFF43F5E); // main accent (rose red)
  static const Color backgroundLight = Color(0xFFF9FAFB); // light background
  static const Color backgroundDark = Color(0xFF111827); // dark background

  static const Color cardColor = Color(0xFF1E293B); // slate-dark card
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA1A1AA); // neutral grey
  static const Color accentColor = Color(0xFFF43F5E); // same as primary for brand consistency
  static const Color green = Color.fromARGB(255, 0, 255, 72); // same as primary for brand consistency
  static const Color red = Color.fromARGB(255, 255, 0, 0); // same as primary for brand consistency

  static const Color white = Colors.white;
  static const Color grey = Color(0xFF9CA3AF);
  static const Color lightGrey = Color(0xFFE5E7EB);
  static const Color errorColor = Color(0xFFEF4444); // red-500 for errors

  // 🔸 Material Swatch for Primary (Rose Red tone)
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFF43F5E,
    <int, Color>{
      50: Color(0xFFFFE4E9),
      100: Color(0xFFFFB8C4),
      200: Color(0xFFFF8AA0),
      300: Color(0xFFFF5C7B),
      400: Color(0xFFFF335F),
      500: Color(0xFFF43F5E),
      600: Color(0xFFE63750),
      700: Color(0xFFD02D44),
      800: Color(0xFFBA2438),
      900: Color(0xFF9C182A),
    },
  );

  //  LIGHT THEME
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: primarySwatch,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: const Color.fromARGB(255, 244, 244, 244),
        // cardColor: const Color.fromARGB(255, 242, 242, 242),
        cardColor: backgroundLight,
        disabledColor:  const Color.fromARGB(106, 0, 0, 0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 249, 250, 251),
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

  //  DARK THEME
  static ThemeData get darkTheme => ThemeData(
    disabledColor: Colors.white54,
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
          bodyMedium: TextStyle(color: Colors.white),
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
