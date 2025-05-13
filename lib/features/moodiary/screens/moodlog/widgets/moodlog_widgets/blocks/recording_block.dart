import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/models/recording_block_model.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/moodlog_widgets/blocks/recording_icon.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
