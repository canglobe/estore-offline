import 'package:flutter/material.dart';
import 'package:estore/constants/constants.dart';

ThemeData darkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      // headline
      headlineLarge: TextStyle(
          color: textDarkColor, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: textDarkColor, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: textDarkColor, fontSize: 18, fontWeight: FontWeight.bold),
      // display
      displayLarge: TextStyle(color: textDarkColor, fontSize: 24),
      displayMedium: TextStyle(color: textDarkColor, fontSize: 20),
      displaySmall: TextStyle(color: textDarkColor, fontSize: 18),
      // label
      labelLarge: TextStyle(color: textDarkColor, fontSize: 16),
      labelMedium: TextStyle(color: textDarkColor, fontSize: 14),
      labelSmall: TextStyle(color: textDarkColor, fontSize: 12),
      // title
      titleLarge: TextStyle(color: textLightColor, fontSize: 18),
      titleMedium: TextStyle(color: textLightColor, fontSize: 16),
      titleSmall: TextStyle(color: textLightColor, fontSize: 14),
      // body
      bodyLarge: TextStyle(color: primaryTextColor, fontSize: 18),
      bodyMedium: TextStyle(color: primaryTextColor, fontSize: 16),
      bodySmall: TextStyle(color: primaryTextColor, fontSize: 14),
    ),
  );
}

ThemeData lightThemeData() {
  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,
    primaryColorLight: primaryColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: scaffoldBgColor,
    textTheme: const TextTheme(
      // headline
      headlineLarge: TextStyle(
          color: textDarkColor, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: textDarkColor, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: textDarkColor, fontSize: 18, fontWeight: FontWeight.bold),
      // display
      displayLarge: TextStyle(color: textLightColor, fontSize: 24),
      displayMedium: TextStyle(color: textLightColor, fontSize: 20),
      displaySmall: TextStyle(color: textLightColor, fontSize: 18),
      // label
      labelLarge: TextStyle(color: textDarkColor, fontSize: 16),
      labelMedium: TextStyle(color: miniTextColor, fontSize: 14),
      labelSmall: TextStyle(color: miniTextColor, fontSize: 12),
      // title
      titleLarge: TextStyle(color: textLightColor, fontSize: 18),
      titleMedium: TextStyle(color: textLightColor, fontSize: 16),
      titleSmall: TextStyle(color: textLightColor, fontSize: 14),
      // body
      bodyLarge: TextStyle(color: primaryTextColor, fontSize: 18),
      bodyMedium: TextStyle(color: primaryTextColor, fontSize: 16),
      bodySmall: TextStyle(color: primaryTextColor, fontSize: 14),
    ),
  );
}
