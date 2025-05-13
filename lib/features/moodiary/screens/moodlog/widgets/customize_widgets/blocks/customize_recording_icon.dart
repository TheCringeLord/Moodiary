import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/models/recording_icon_mode.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/predefined_icon_picker.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../../../../../data/repositories/mood/recording_block_repository.dart';
import '../../../../../controllers/icon_block_controller.dart';
import '../../../../../controllers/recording_block_controller.dart';
import '../../../../../models/icon_metadata.dart';

class TCustomizeRecordingIcon extends StatelessWidget {
  final RecordingIconModel icon;
  final String blockId;
  final double size;

  const TCustomizeRecordingIcon({
    super.key,
    required this.icon,
    required this.blockId,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: dark ? TColors.dark : TColors.white,
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _TEditIconDialog(icon: icon, blockId: blockId),
        );
      },
      // Icon customization modal
      child: Column(
        children: [
          TRoundedContainer(
            width: size,
            height: size,
            radius: size / 2,
            backgroundColor: dark ? TColors.white : TColors.light,
            child: Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Image.asset(
                icon.iconPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            icon.label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: dark ? TColors.light : TColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}

class _TEditIconDialog extends StatelessWidget {
  final RecordingIconModel icon;
  final String blockId;

  const _TEditIconDialog({
    required this.icon,
    required this.blockId,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final iconCtrl = IconBlockController.instance;

    // Initialize the reactive properties
    iconCtrl.setTempIconPath(icon.iconPath);
    iconCtrl.setEditingLabel(icon.label);

    return Padding(
      padding: EdgeInsets.only(
        left: TSizes.defaultSpace,
        right: TSizes.defaultSpace,
        top: TSizes.defaultSpace,
        // This is key - adjust padding for keyboard
        bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.defaultSpace,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon.label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Icon with overlays pencil
          GestureDetector(
            onTap: () {
              showModalBottomSheet<IconMetadata>(
                backgroundColor: dark ? TColors.dark : TColors.white,
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const TPredefinedIconPicker(),
              ).then((selectedIcon) {
                if (selectedIcon != null) {
                  // 1) update the temp path so Obx rebuilds the dialog UI
                  iconCtrl.setTempIconPath(selectedIcon.iconPath);

                  // 2) update your block model + save
                  final recordingCtrl = RecordingBlockController.instance;

                  final blockIndex = recordingCtrl.recordingBlocks
                      .indexWhere((b) => b.id == blockId);
                  if (blockIndex == -1) return;

                  final block = recordingCtrl.recordingBlocks[blockIndex];
                  final iconIndex =
                      block.icons.indexWhere((i) => i.id == icon.id);
                  if (iconIndex == -1) return;

                  // Replace the icon object
                  final updatedIcon = RecordingIconModel(
                    id: icon.id,
                    label: icon.label,
                    iconPath: selectedIcon.iconPath,
                    isCustom: icon.isCustom,
                  );
                  block.icons[iconIndex] = updatedIcon;

                  // Trigger UI update
                  recordingCtrl.recordingBlocks[blockIndex] = block;
                  recordingCtrl.recordingBlocks.refresh();

                  // Save to Firebase
                  RecordingBlockRepository.instance.updateBlock(block);
                }
              });
            },
            child: Obx(() {
              final displayedPath = iconCtrl.selectedIconPath.value.isNotEmpty
                  ? iconCtrl.selectedIconPath.value
                  : icon.iconPath;

              return Stack(
                alignment: Alignment.center,
                children: [
                  TRoundedContainer(
                    width: 70,
                    height: 70,
                    radius: 35,
                    backgroundColor: dark ? TColors.white : TColors.light,
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.iconXs),
                      child: Image.asset(
                        displayedPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: TColors.primary,
                      child: Icon(Iconsax.edit, size: 16, color: TColors.white),
                    ),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /// Rename icon field using Obx and reactive label
          Obx(() => TextFormField(
                initialValue: iconCtrl.editingLabel.value,
                maxLength: 12,
                // This onChanged handler is crucial
                onChanged: (value) => iconCtrl.setEditingLabel(value),
                decoration: const InputDecoration(
                  labelText: "Rename icon",
                  border: OutlineInputBorder(),
                ),
              )),

          const SizedBox(height: TSizes.spaceBtwItems),

          /// Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Delete
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Get.back(); // Close context menu or bottom sheet

                    Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(TSizes.cardRadiusLg),
                        ),
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Are you sure?",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              Text(
                                "This will permanently delete the icon and all related records.",
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
                                        IconBlockController.instance
                                            .deleteIconFromBlock(
                                                blockId, icon.id);
                                        iconCtrl.resetTempIconPath();
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Iconsax.trash, color: TColors.error),
                  label: Text(
                    "Delete",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.error),
                  ),
                ),
              ),

              /// Save rename - use the reactive label now
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Get value directly from controller
                    final newLabel = iconCtrl.editingLabel.value.trim();
                    if (newLabel.isNotEmpty) {
                      IconBlockController.instance.updateIconLabel(
                        blockId,
                        icon.id,
                        newLabel,
                      );
                    }
                    iconCtrl.resetTempIconPath();
                    iconCtrl.resetEditingLabel();
                    Get.back();
                  },
                  child: Text(
                    "Save",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
