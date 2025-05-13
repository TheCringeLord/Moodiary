import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/moodlog_widgets/mood/mood_selector.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/moodlog_widgets/note_block/notes_block.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/moodlog_widgets/blocks/recording_block.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/moodlog_widgets/sleep_block/sleep_block.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

import '../../../../utils/loaders/shimmer_effect.dart';
import '../../controllers/mood_controller.dart';
import '../../controllers/recording_block_controller.dart';
import '../../models/mood_model.dart';
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
