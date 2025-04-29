import 'package:flutter/material.dart';
import 'package:moodiary/features/moodiary-old/models/mood_model.dart';

import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

/// Custom tile widget for calendar day representation.
class TDateTile extends StatelessWidget {
  const TDateTile({
    super.key,
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.color = TColors.primary,
    this.size = 50,
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
    final showCircleBorder = isToday;
    final dark = THelperFunctions.isDarkMode(context);
    final circleBg = Mood.getBackgroundColor(mood, dark);

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
                Mood.getMoodImage(mood!),
                fit: BoxFit.cover,
                width: size,
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
}
