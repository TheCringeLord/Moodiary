import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/notes_block_customize.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/sleep_block_customize.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/customize_recording_block.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/loaders/shimmer_effect.dart';

class THiddenBlockTab extends StatelessWidget {
  const THiddenBlockTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Obx(() {
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
                for (final block in recordingController.hiddenBlocks) ...[
                  if (block.id == 'sleep')
                    const TSleepBlockCustomize()
                  else if (block.id == 'notes')
                    const TNotesBlockCustomize()
                  else
                    TCustomizeRecordingBlock(block: block),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
            ],
          );
        }),
      ),
    );
  }
}
