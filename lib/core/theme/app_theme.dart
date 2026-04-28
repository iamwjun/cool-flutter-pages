import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF16E0FF),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF030914),
      colorScheme: baseScheme.copyWith(
        primary: const Color(0xFF16E0FF),
        secondary: const Color(0xFFFF7A18),
        surface: const Color(0xFF081426),
      ),
      textTheme: ThemeData(
        brightness: Brightness.dark,
      ).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
    );
  }
}
