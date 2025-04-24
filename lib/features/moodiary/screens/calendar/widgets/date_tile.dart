import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/image_strings.dart';

/// Custom tile widget for calendar day representation.
class TDateTile extends StatelessWidget {
  const TDateTile({
    super.key,
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.color = TColors.primary,
    this.size = 56,
    this.mood,
  });
  final int day;
  final bool isToday;
  final bool isSelected;
  final Color color;
  final double size;
  final String? mood;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final showCircleBorder = isToday;

    // Determine circle background color based on mood
    Color circleBg;
    if (mood != null) {
      // Map mood strings to colors
      switch (mood) {
        case 'veryHappy':
          circleBg = const Color.fromARGB(255, 220, 241, 162);
          break;
        case 'happy':
          circleBg = Colors.yellow.shade200;
          break;
        case 'neutral':
          circleBg = const Color.fromARGB(255, 214, 193, 161);
          break;
        case 'unHappy':
          circleBg = const Color.fromARGB(255, 240, 154, 105);
          break;
        case 'sad':
          circleBg = const Color.fromARGB(255, 189, 183, 248);
          break;
        default:
          circleBg = dark ? TColors.textPrimary : TColors.white;
      }
    } else {
      circleBg = dark ? TColors.textPrimary : TColors.white;
    }

    Color containerBg;
    Color textColor;

    if (isSelected) {
      containerBg = color;
      textColor = TColors.white;
    } else if (isToday) {
      containerBg = Colors.transparent;
      textColor = color;
    } else {
      containerBg = Colors.transparent;
      textColor = Theme.of(context).textTheme.labelLarge!.color!;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            TRoundedContainer(
              width: size,
              height: size,
              radius: size / 2,
              showBorder: showCircleBorder,
              borderColor: color,
              backgroundColor: circleBg,
            ),
            if (mood != null)
              Image.asset(
                getMoodImage(mood!),
                fit: BoxFit.cover,
                width: size * 0.8,
              ),
          ],
        ),
        const SizedBox(height: TSizes.xs),
        TRoundedContainer(
          padding: EdgeInsets.zero,
          backgroundColor: containerBg,
          child: SizedBox(
            width: size,
            child: Center(
              child: Text(
                '$day',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: textColor,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getMoodImage(String mood) {
    switch (mood) {
      case 'veryHappy':
        return TImages.veryHappy;
      case 'happy':
        return TImages.happy;
      case 'neutral':
        return TImages.neutral;
      case 'unHappy':
        return TImages.unHappy;
      case 'sad':
        return TImages.sad;
      default:
        return TImages.neutral; // fallback image
    }
  }
}
