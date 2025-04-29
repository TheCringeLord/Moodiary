import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';

class Mood {
  final String iconPath;
  final String value;
  final Color backgroundColor;

  const Mood({
    required this.iconPath,
    required this.value,
    required this.backgroundColor,
  });

  static List<Mood> get defaultMoods => [
        Mood(
          iconPath: TImages.veryHappy,
          value: 'Very Happy',
          backgroundColor: const Color.fromARGB(255, 220, 241, 162),
        ),
        Mood(
          iconPath: TImages.happy,
          value: 'Happy',
          backgroundColor: Colors.yellow.shade200,
        ),
        Mood(
          iconPath: TImages.neutral,
          value: 'Neutral',
          backgroundColor: const Color.fromARGB(255, 214, 193, 161),
        ),
        Mood(
          iconPath: TImages.unHappy,
          value: 'Unhappy',
          backgroundColor: const Color.fromARGB(255, 240, 154, 105),
        ),
        Mood(
          iconPath: TImages.sad,
          value: 'Very Sad',
          backgroundColor: const Color.fromARGB(255, 189, 183, 248),
        ),
      ];

  static Color getBackgroundColor(String? moodValue, bool isDark) {
    if (moodValue == null) {
      return isDark ? TColors.textPrimary : TColors.white;
    }

    final mood = defaultMoods.firstWhere(
      (m) => m.value == moodValue,
      orElse: () => defaultMoods[2], // Default to neutral
    );
    return mood.backgroundColor;
  }

  static String getMoodImage(String moodValue) {
    final mood = defaultMoods.firstWhere(
      (m) => m.value == moodValue,
      orElse: () => defaultMoods[2], // Default to neutral
    );
    return mood.iconPath;
  }
}
