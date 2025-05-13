import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/mood_controller.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/widgets/moodlog_widgets/mood/mood_icon.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TMoodSelector extends StatelessWidget {
  const TMoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final moodController = MoodController.instance;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      backgroundColor: THelperFunctions.isDarkMode(context)
          ? TColors.textPrimary
          : TColors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "How was your day?",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          ///* Main Mood Selection
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //* Main Mood
                TMoodIcon(
                  imagePath: TImages.veryHappy,
                  isSelected:
                      moodController.selectedMainMood.value == 'veryHappy',
                  onTap: () => moodController.selectMainMood('veryHappy'),
                ),
                TMoodIcon(
                  imagePath: TImages.happy,
                  isSelected: moodController.selectedMainMood.value == 'happy',
                  onTap: () => moodController.selectMainMood('happy'),
                ),
                TMoodIcon(
                  imagePath: TImages.neutral,
                  isSelected:
                      moodController.selectedMainMood.value == 'neutral',
                  onTap: () => moodController.selectMainMood('neutral'),
                ),
                TMoodIcon(
                  imagePath: TImages.unHappy,
                  isSelected:
                      moodController.selectedMainMood.value == 'unhappy',
                  onTap: () => moodController.selectMainMood('unhappy'),
                ),
                TMoodIcon(
                  imagePath: TImages.sad,
                  isSelected: moodController.selectedMainMood.value == 'sad',
                  onTap: () => moodController.selectMainMood('sad'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
