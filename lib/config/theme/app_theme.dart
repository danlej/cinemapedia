import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;

  AppTheme({
    this.isDarkMode = true,
  });

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: const Color(0xFF2862F5),
      );

  AppTheme copyWith({bool? isDarkMode}) =>
      AppTheme(isDarkMode: isDarkMode ?? this.isDarkMode);
}
