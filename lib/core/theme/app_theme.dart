import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    const black = Color(0xFF000000);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        surface: black,
        primary: Color(0xFF8E9AAF),
        onSurface: Color(0xFFE8E8E8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        foregroundColor: Color(0xFFE8E8E8),
        elevation: 0,
      ),
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.onDrag,
      ),
    );
  }
}
