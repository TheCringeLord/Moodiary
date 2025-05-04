import 'package:flutter/material.dart';

class TColors {
  // App theme colors
  static const Color primary = Color.fromARGB(255, 126, 160, 255);
  static const Color secondary = Color.fromARGB(255, 212, 234, 230);
  static const Color accent = Color.fromARGB(255, 48, 134, 125);

  //Gradient Colors
  static Gradient darkLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 149, 255, 205).withAlpha(255),
      Color.fromARGB(255, 34, 223, 236).withAlpha(150),
      Color.fromARGB(255, 160, 212, 255).withAlpha(80),
      Color.fromARGB(255, 238, 255, 160).withAlpha(30),
      Color.fromARGB(255, 255, 238, 160).withAlpha(0)
    ],
  );
  static Gradient lightLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 103, 167, 250).withAlpha(150),
      Color.fromARGB(255, 123, 213, 255).withAlpha(80),
      Color.fromARGB(255, 149, 221, 255).withAlpha(50),
      Color.fromARGB(255, 160, 255, 231).withAlpha(10),
      Color.fromARGB(255, 160, 255, 219).withAlpha(0)
    ],
  );

  // Text colors
  static const Color textPrimary = Color.fromARGB(255, 55, 57, 79);
  static const Color textSecondary = Color.fromARGB(255, 120, 127, 156);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color.fromARGB(255, 237, 240, 252);
  static const Color dark = Color.fromARGB(255, 18, 23, 37);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = TColors.white.withOpacity(0.1);

  // Button colors
  static const Color buttonPrimary = Color.fromARGB(255, 255, 75, 75);
  static const Color buttonSecondary = Color.fromARGB(255, 125, 108, 108);
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
