import 'package:flutter/material.dart';

class TColors {
  // App theme colors
  static const Color primary = Color.fromARGB(255, 126, 191, 255);
  static const Color secondary = Color.fromARGB(255, 212, 234, 230);
  static const Color accent = Color.fromARGB(255, 48, 134, 125);

  //Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
    ],
  );

  // Text colors
  static const Color textPrimary = Color.fromARGB(255, 55, 71, 79);
  static const Color textSecondary = Color.fromARGB(255, 120, 144, 156);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color.fromARGB(255, 237, 243, 252);
  static const Color dark = Color.fromARGB(255, 18, 27, 37);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = TColors.white.withOpacity(0.1);

  // Button colors
  static const Color buttonPrimary = Color.fromARGB(255, 75, 147, 255);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color.fromARGB(255, 211, 47, 47);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
