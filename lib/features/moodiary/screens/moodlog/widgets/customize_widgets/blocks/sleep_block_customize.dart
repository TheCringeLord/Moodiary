import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/hide_block_controller.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TSleepBlockCustomize extends StatelessWidget {
  const TSleepBlockCustomize({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final block = RecordingBlockController.instance.recordingBlocks
        .firstWhere((block) => block.id == 'sleep');
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
              Row(
                children: [
                  Text(
                    "Sleep",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      final isHidden = block.isHidden;

                      showModalBottomSheet(
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => Padding(
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(
                                  isHidden ? Iconsax.eye : Iconsax.eye_slash,
                                ),
                                title: Text(
                                    isHidden ? "Unhide Block" : "Hide Block"),
                                onTap: () {
                                  Get.back();
                                  HideBlockController.instance
                                      .toggleVisibility(block.id, !isHidden);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Iconsax.more, size: TSizes.iconSm),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: null,
              icon: Icon(
                Iconsax.moon,
                color: THelperFunctions.isDarkMode(context)
                    ? TColors.light
                    : TColors.darkGrey,
              ),
              label: Text(
                "Record Sleep Hours",
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
          ),
        ],
      ),
    );
  }
}
