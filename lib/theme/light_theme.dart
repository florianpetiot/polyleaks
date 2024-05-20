import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.blue
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey[300],
    ),
  ),

  colorScheme: ColorScheme.light(
    primary: Colors.grey[100]!,
    secondary: Colors.grey[400]!,
    tertiary: Colors.grey,

    inversePrimary: Colors.grey[600]!,

    surface: Colors.white,
    surfaceVariant: Colors.grey.withOpacity(0.3),

    shadow: Colors.black.withOpacity(0.5),
  ),
);