import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.blue
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.grey[800],
    ),
  ),

  colorScheme: ColorScheme.dark(
    primary: Colors.grey[800]!,
    secondary: Colors.grey[600]!,
    tertiary: Colors.grey[300]!,

    inversePrimary: Colors.grey[100]!,

    surface: Colors.grey[800]!,
    surfaceVariant: Colors.grey.withOpacity(0.3),

    shadow: Colors.grey.withOpacity(0.2),
  ),
);