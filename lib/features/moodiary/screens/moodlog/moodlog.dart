import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shape/container/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/mood_controller.dart';

class MoodlogScreen extends StatelessWidget {
  const MoodlogScreen({super.key, required this.selectedDate});
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final moodController = Get.put(MoodController());

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          THelperFunctions.getFormattedDateDayMonthYear(
            selectedDate,
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.setting_2),
          ),
        ],
        showBackArrow: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///* Main Mood Selection
              TRoundedContainer(
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
                            isSelected: moodController.selectedMainMood.value ==
                                'veryHappy',
                            onTap: () =>
                                moodController.selectMainMood('veryHappy'),
                          ),
                          TMoodIcon(
                            imagePath: TImages.happy,
                            isSelected: moodController.selectedMainMood.value ==
                                'happy',
                            onTap: () => moodController.selectMainMood('happy'),
                          ),
                          TMoodIcon(
                            imagePath: TImages.neutral,
                            isSelected: moodController.selectedMainMood.value ==
                                'neutral',
                            onTap: () =>
                                moodController.selectMainMood('neutral'),
                          ),
                          TMoodIcon(
                            imagePath: TImages.unHappy,
                            isSelected: moodController.selectedMainMood.value ==
                                'unhappy',
                            onTap: () =>
                                moodController.selectMainMood('unhappy'),
                          ),
                          TMoodIcon(
                            imagePath: TImages.sad,
                            isSelected:
                                moodController.selectedMainMood.value == 'sad',
                            onTap: () => moodController.selectMainMood('sad'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              ///TODO: Other Activities Block to be added here
            ],
          ),
        ),
      ),

      ///* Done Button Click to save mood log
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => moodController.saveMood(selectedDate),
          child: const Text("Done"),
        ),
      ),
    );
  }
}

class TMoodIcon extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const TMoodIcon({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.isSelected = false,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TRoundedContainer(
            width: size,
            height: size,
            radius: size / 2,
            showBorder: isSelected,
            backgroundColor: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
          ),
          ClipOval(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.transparent : Colors.grey,
                BlendMode.saturation,
              ),
              child: Image.asset(
                imagePath,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
