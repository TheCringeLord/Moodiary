import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/mood_controller.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/moodlog_widgets/sleep_block/sleep_picker_dialog.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
