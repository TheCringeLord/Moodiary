import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/sleep_picker_dialog.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shape/container/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

import '../../../../utils/loaders/shimmer_effect.dart';
import '../../../../utils/validators/validation.dart';
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
    final recordingBlockController = Get.put(RecordingBlockController());

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
              Obx(() {
                final blocks = MoodController.instance.activeBlocks;

                final isLoading = recordingBlockController.isLoading.value;
                final numberOfBlocks = blocks.length;
                final normalBlocks = blocks.where((b) => !b.isSpecial).toList();
                final specialBlocks = blocks.where((b) => b.isSpecial).toList();

                return Column(
                  children: [
                    ///* 🔹 Normal blocks or shimmer
                    if (isLoading)
                      ...List.generate(
                          numberOfBlocks,
                          (_) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: TSizes.spaceBtwSections / 2),
                                child: const TShimmerEffect(
                                    width: double.infinity, height: 100),
                              ))
                    else
                      for (final block in normalBlocks) ...[
                        TRecordingBlock(block: block),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],

                    ///* 🔸 Then special blocks
                    for (final block in specialBlocks) ...[
                      if (block.id == 'sleep')
                        const TSleepBlock()
                      else if (block.id == 'notes')
                        const TNotesBlock(),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ],
                );
              }),
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

class TNotesBlock extends StatelessWidget {
  const TNotesBlock({super.key});

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
                "Today's Notes",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          ///* Text field for notes
          Form(
            key: MoodController.instance.notesFormKey,
            child: TextFormField(
              controller: MoodController.instance.notes,
              validator: (value) =>
                  TValidator.validateEmptyText("Notes", value),
              decoration: const InputDecoration(
                labelText: "Enter your notes here...",
                suffixIcon: Icon(Iconsax.note_1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TSleepBlock extends StatelessWidget {
  const TSleepBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = MoodController.instance;
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
                "Sleep",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          ///* Record Sleep Hours
          Obx(() {
            final start = controller.sleepStart.value;
            final end = controller.sleepEnd.value;
            final hasSaved = controller.sleepDurationInMinutes > 0;
            final label = hasSaved
                ? '${start.format(context)} ~ ${end.format(context)}'
                : 'Record Sleep Hours';

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => const TSleepPickerDialog(),
                ),
                icon: Icon(
                  Iconsax.moon,
                  color: THelperFunctions.isDarkMode(context)
                      ? TColors.light
                      : TColors.darkGrey,
                ),
                label: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium!.apply(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.darkGrey),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: THelperFunctions.isDarkMode(context)
                      ? TColors.textSecondary
                      : TColors.lightContainer,
                  side: BorderSide(
                    color: THelperFunctions.isDarkMode(context)
                        ? TColors.light
                        : TColors.grey,
                  ),
                ),
              ),
            );
          }),
        ],
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
                icon: const Icon(
                  Iconsax.arrow_down_1,
                  size: TSizes.iconSm,
                ),
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
