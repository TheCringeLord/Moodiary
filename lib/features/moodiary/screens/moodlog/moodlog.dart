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
import '../../models/mood_model.dart';
import '../../models/recording_block_model.dart';
import '../../models/recording_icon_mode.dart';
import 'customize_recording_block.dart';

class MoodlogScreen extends StatelessWidget {
  const MoodlogScreen({
    super.key,
    required this.selectedDate,
    this.existingMood,
  });
  final DateTime selectedDate;
  final MoodModel? existingMood;
  @override
  Widget build(BuildContext context) {
    final moodController = Get.put(MoodController());
    final recordingBlockController = Get.put(RecordingBlockController());

    if (moodController.recordingBlocks.isEmpty) {
      moodController.loadBlocks();
    }

    // if we're editing, prefill the controller once
    if (existingMood != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        moodController.clear();
        moodController.selectedMainMood.value = existingMood!.mainMood;
        moodController.notes.text = existingMood!.note ?? '';
        if (existingMood!.sleepStart != null &&
            existingMood!.sleepEnd != null) {
          moodController.isSleepSaved.value = true;
          final ss = existingMood!.sleepStart!;
          final se = existingMood!.sleepEnd!;
          moodController.sleepStart.value =
              TimeOfDay(hour: ss.hour, minute: ss.minute);
          moodController.sleepEnd.value =
              TimeOfDay(hour: se.hour, minute: se.minute);
        }
        // fill the built-in blocks
        if (existingMood!.emotions != null) {
          moodController.selectedIconsPerBlock['emotions'] =
              RxList(existingMood!.emotions!);
        }
        if (existingMood!.weather != null) {
          moodController.selectedIconsPerBlock['weather'] =
              RxList(existingMood!.weather!);
        }
        if (existingMood!.people != null) {
          moodController.selectedIconsPerBlock['people'] =
              RxList(existingMood!.people!);
        }
        if (existingMood!.hobbies != null) {
          moodController.selectedIconsPerBlock['hobbies'] =
              RxList(existingMood!.hobbies!);
        }
        if (existingMood!.work != null) {
          moodController.selectedIconsPerBlock['work'] =
              RxList(existingMood!.work!);
        }
        if (existingMood!.health != null) {
          moodController.selectedIconsPerBlock['health'] =
              RxList(existingMood!.health!);
        }
        if (existingMood!.chores != null) {
          moodController.selectedIconsPerBlock['chores'] =
              RxList(existingMood!.chores!);
        }
        if (existingMood!.relationship != null) {
          moodController.selectedIconsPerBlock['relationship'] =
              RxList(existingMood!.relationship!);
        }
        if (existingMood!.other != null) {
          moodController.selectedIconsPerBlock['other'] =
              RxList(existingMood!.other!);
        }

        // fill any custom blocks
        existingMood!.customBlocks?.forEach((blockId, items) {
          moodController.selectedIconsPerBlock[blockId] = RxList(items);
        });
      });
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
              const TMoodSelector(),

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
                          (_) => const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: TSizes.spaceBtwSections / 2),
                                child: TShimmerEffect(
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

  TRecordingBlock({super.key, required this.block});

  // Create a reactive state for expansion per block instance
  final RxBool isExpanded = true.obs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(
      () => TRoundedContainer(
        backgroundColor: dark ? TColors.textPrimary : TColors.white,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///* Block title with toggle icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  block.displayName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => isExpanded.toggle(),
                  icon: Icon(
                    isExpanded.value
                        ? Iconsax.arrow_up_2
                        : Iconsax.arrow_down_1,
                    size: TSizes.iconSm,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///* Icons
            if (isExpanded.value)
              Wrap(
                spacing: TSizes.spaceBtwItems,
                runSpacing: TSizes.spaceBtwItems,
                children: block.icons.map((icon) {
                  return TRecordingIcon(icon: icon, blockId: block.id);
                }).toList(),
              ),
          ],
        ),
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
              // … inside TRecordingIcon.build(), replace the TRoundedContainer child with:

              TRoundedContainer(
                width: size,
                height: size,
                radius: size / 2,
                backgroundColor: isSelected
                    ? TColors.light
                    : dark
                        ? TColors.white
                        : TColors.grey,
                child: ClipOval(
                  child: ColorFiltered(
                    colorFilter: isSelected
                        ? const ColorFilter.mode(
                            Colors.transparent, BlendMode.saturation)
                        : dark
                            ? const ColorFilter.mode(
                                TColors.lightGrey, BlendMode.saturation)
                            : const ColorFilter.mode(
                                TColors.grey, BlendMode.saturation),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: Image.asset(
                        icon.iconPath,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
