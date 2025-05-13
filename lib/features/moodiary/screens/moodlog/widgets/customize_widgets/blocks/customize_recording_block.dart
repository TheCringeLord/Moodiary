import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/common/widgets/dialog/bottom_dialog.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/hide_block_controller.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/update_block_name_controller.dart';
import 'package:moodiary/features/moodiary/models/recording_block_model.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/add_icon_button.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/customize_recording_icon.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/dialog.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TCustomizeRecordingBlock extends StatelessWidget {
  final RecordingBlockModel block;

  TCustomizeRecordingBlock({super.key, required this.block});

  final RxBool isExpanded = true.obs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final updateCtrl = UpdateBlockNameController.instance;

    return Obx(
      () => TRoundedContainer(
        backgroundColor: dark ? TColors.textPrimary : TColors.white,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Block title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      block.displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        updateCtrl.initializeName(block);
                        showModalBottomSheet(
                          backgroundColor: dark ? TColors.dark : TColors.white,
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => TBottomDialog(
                            title: "Rename Block",
                            controller: updateCtrl.blockName,
                            formKey: updateCtrl.formKey,
                            onConfirm: () {
                              updateCtrl.updateBlockName();
                            },
                          ),
                        );
                      },
                      icon: const Icon(Iconsax.edit, size: TSizes.iconSm),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        final isSpecial = block.isSpecial;
                        final isHidden = block.isHidden;

                        showModalBottomSheet(
                          context: context,
                          backgroundColor: dark ? TColors.dark : TColors.white,
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
                                  leading: Icon(isHidden
                                      ? Iconsax.eye
                                      : Iconsax.eye_slash),
                                  title: Text(
                                      isHidden ? "Unhide Block" : "Hide Block"),
                                  onTap: () {
                                    Get.back();
                                    HideBlockController.instance
                                        .toggleVisibility(block.id, !isHidden);
                                  },
                                ),
                                if (!isSpecial)
                                  ListTile(
                                    leading: const Icon(
                                      Iconsax.trash,
                                      color: TColors.error,
                                    ),
                                    title: const Text(
                                      "Delete Block",
                                      style: TextStyle(color: TColors.error),
                                    ),
                                    onTap: () {
                                      Get.back();
                                      Get.dialog(TDialog(block: block));
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Iconsax.more, size: TSizes.iconSm),
                    ),

                    /// Expand/collapse toggle
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
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            /// Block icons
            if (isExpanded.value)
              Wrap(
                spacing: TSizes.spaceBtwItems,
                runSpacing: TSizes.spaceBtwItems,
                children: [
                  for (final icon in block.icons)
                    TCustomizeRecordingIcon(icon: icon, blockId: block.id),
                  TAddIconButton(blockId: block.id),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
