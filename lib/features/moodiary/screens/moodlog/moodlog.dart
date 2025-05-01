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
import '../../controllers/recording_block_controller.dart';
import '../../models/recording_block_model.dart';
import '../../models/recording_icon_mode.dart';
import 'customize_recording_block.dart';

class MoodlogScreen extends StatelessWidget {
  const MoodlogScreen({super.key, required this.selectedDate});
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final moodController = Get.put(MoodController());
    Get.put(RecordingBlockController());
    // 👇 Add this block
    if (moodController.recordingBlocks.isEmpty) {
      moodController.loadBlocks();
    }
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
            onPressed: () =>
                Get.to(() => const CustomizeRecordingBlockScreen()),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///* Main Mood Selection
              TMoodSelector(),

              const SizedBox(height: TSizes.spaceBtwSections),

              ///* Recording Blocks
              Obx(
                () => Column(
                  children: [
                    for (final block
                        in MoodController.instance.activeBlocks) ...[
                      TRecordingBlock(block: block),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ],
                ),
              ),
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

class TRecordingBlock extends StatelessWidget {
  final RecordingBlockModel block;

  const TRecordingBlock({
    super.key,
    required this.block,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      backgroundColor: dark ? TColors.textPrimary : TColors.white,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///* Block title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                block.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: () {}, // optional collapse/expand or settings
                icon: const Icon(Iconsax.arrow_down_1),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          ///* Icons
          Wrap(
            spacing: TSizes.spaceBtwItems,
            runSpacing: TSizes.spaceBtwItems,
            children: block.icons.map((icon) {
              return TRecordingIcon(icon: icon, blockId: block.id);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TRecordingIcon extends StatelessWidget {
  final RecordingIconModel icon;
  final String blockId;
  final double size;

  const TRecordingIcon({
    super.key,
    required this.icon,
    required this.blockId,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final moodController = MoodController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(
      () {
        final isSelected = moodController.isIconSelected(blockId, icon.id);
        return GestureDetector(
          onTap: () => moodController.toggleIcon(blockId, icon.id),
          child: Column(
            children: [
              TRoundedContainer(
                width: size,
                height: size,
                radius: size / 2,
                backgroundColor: isSelected ? TColors.primary : TColors.grey,
                child: Icon(
                  Iconsax.gallery,
                  color: isSelected ? TColors.white : TColors.textPrimary,
                  size: size / 2,
                ),
                // child: Image.asset(
                //   icon.iconPath,
                //   width: 30,
                //   height: 30,
                //   fit: BoxFit.contain,
                // ),
              ),
              const SizedBox(height: TSizes.xs),
              Text(
                icon.label,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: isSelected
                          ? TColors.primary
                          : dark
                              ? TColors.white
                              : TColors.textPrimary,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
