import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF5B8DEF),
    scaffoldBackgroundColor: const Color(0xFFF8F9FC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF5B8DEF),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F172A),
      elevation: 0,
      foregroundColor: Colors.white,
    ),
  );
}
