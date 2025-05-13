import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/dialog/bottom_dialog.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/create_block_controller.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/notes_block_customize.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/sleep_block_customize.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/customize_recording_block.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';
import 'package:moodiary/utils/loaders/shimmer_effect.dart';

class TActiveBlockTab extends StatelessWidget {
  const TActiveBlockTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///* Create Block Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final ctrl = CreateBlockController.instance;
                  ctrl.blockName.clear(); // reset

                  showModalBottomSheet(
                    backgroundColor: dark ? TColors.dark : TColors.white,
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => TBottomDialog(
                      title: "Create New Block",
                      controller: ctrl.blockName,
                      formKey: ctrl.formKey,
                      buttonText: "Create new block",
                      onConfirm: () {
                        ctrl.createBlock();
                        Get.back();
                      },
                    ),
                  );
                },
                // Handle create
                icon: const Icon(Iconsax.add, color: TColors.white),
                label: Text(
                  "Create new block",
                  style: Theme.of(context).textTheme.titleMedium!.apply(
                        color: TColors.white,
                      ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Dynamic block list
            Obx(() {
              final recordingController = RecordingBlockController.instance;
              final isLoading = recordingController.isLoading.value;

              return Column(
                children: [
                  /// 🔹 Normal blocks
                  if (isLoading)
                    ...List.generate(
                      3,
                      (_) => const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: TSizes.spaceBtwSections / 2),
                        child: TShimmerEffect(
                            width: double.infinity, height: 100),
                      ),
                    )
                  else
                    for (final block in recordingController.normalBlocks) ...[
                      TCustomizeRecordingBlock(block: block),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],

                  /// 🔸 Special blocks
                  for (final block in recordingController.specialBlocks) ...[
                    if (block.id == 'sleep')
                      const TSleepBlockCustomize()
                    else if (block.id == 'notes')
                      const TNotesBlockCustomize(),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
