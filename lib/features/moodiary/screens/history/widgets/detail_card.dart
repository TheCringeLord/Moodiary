import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/detail_controller.dart';
import 'package:moodiary/features/moodiary/controllers/mood_controller.dart';
import 'package:moodiary/features/moodiary/models/icon_metadata.dart';
import 'package:moodiary/features/moodiary/models/mood_model.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/moodlog.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TDetailCard extends StatelessWidget {
  final MoodModel mood;
  final List<IconMetadata> icons;

  const TDetailCard({super.key, required this.mood, required this.icons});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final day = DateFormat('dd').format(mood.date);
    final weekday = DateFormat('EEE').format(mood.date);
    final moodController = Get.put(MoodController());
    Get.put(DetailController());
    return Column(
      children: [
        ///* Delete Edit mood button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Get.dialog(Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  backgroundColor: dark ? TColors.dark : TColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delete Records?",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Text(
                          "This will permanently delete the records for this day.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                ),
                                onPressed: () => Get.back(),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.error,
                                  side: const BorderSide(
                                    color: TColors.error,
                                  ),
                                ),
                                onPressed: () {
                                  Get.back();
                                  moodController.deleteMood(mood.id);
                                },
                                child: const Text("Delete"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
              },
              icon: const Icon(
                Iconsax.trash,
                size: TSizes.iconMd,
              ),
            ),

            ///* Edit mood button
            IconButton(
              onPressed: () => Get.to(() => MoodlogScreen(
                    selectedDate: mood.date,
                    existingMood: mood,
                  )),
              icon: const Icon(
                Iconsax.edit_2,
                size: TSizes.iconMd,
              ),
            ),
          ],
        ),
        TRoundedContainer(
          backgroundColor: dark ? TColors.textPrimary : TColors.white,
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // date & main mood
              Row(
                children: [
                  Image.asset(
                    THelperFunctions.getMoodIconPath(mood.mainMood),
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(width: TSizes.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$day  $weekday",
                          style: Theme.of(context).textTheme.titleMedium),
                      Text("Mood: ${mood.mainMood.toLowerCase()}",
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // icons
              if (icons.isNotEmpty)
                Wrap(
                  spacing: TSizes.sm,
                  runSpacing: TSizes.sm,
                  children: icons
                      .map(
                        (icon) => TRoundedContainer(
                          width: 50,
                          height: 50,
                          radius: 25,
                          padding: const EdgeInsets.all(TSizes.sm),
                          backgroundColor: dark ? TColors.white : TColors.light,
                          child: Image.asset(icon.iconPath),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: TSizes.spaceBtwItems),

              // note
              if (mood.note?.isNotEmpty ?? false)
                Text(mood.note!, style: Theme.of(context).textTheme.bodyMedium),

              // sleep
              if (mood.sleepStart != null && mood.sleepEnd != null)
                Padding(
                  padding: const EdgeInsets.only(top: TSizes.spaceBtwItems),
                  child: Row(
                    children: [
                      const Icon(Icons.nights_stay_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "${DateFormat.jm().format(mood.sleepStart!)} – "
                        "${DateFormat.jm().format(mood.sleepEnd!)}",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
