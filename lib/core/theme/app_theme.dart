import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
    useMaterial3: false,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 30.0, color: Colors.white),
      titleMedium: TextStyle(fontSize: 25, color: Colors.white),
      titleSmall: TextStyle(fontSize: 20, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 15, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 12, color: Colors.white),

      // headlineSmall: TextStyle(fontSize: 24, color: Colors.white),
    ),
  );
}
