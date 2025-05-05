import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/delete_block_controller.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/hide_block_controller.dart';

import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/custom_shape/container/rounded_container.dart';

import '../../../../common/widgets/dialog/bottom_dialog.dart';
import '../../../../data/repositories/mood/recording_block_repository.dart';
import '../../../../utils/loaders/shimmer_effect.dart';
import '../../controllers/icon_block_controller.dart';
import '../../controllers/CRUD_recording_block/create_block_controller.dart';
import '../../controllers/recording_block_controller.dart';
import '../../controllers/CRUD_recording_block/update_block_name_controller.dart';
import '../../models/icon_metadata.dart';
import '../../models/recording_block_model.dart';
import '../../models/recording_icon_mode.dart';

class CustomizeRecordingBlockScreen extends StatelessWidget {
  const CustomizeRecordingBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    ///* Initialize RecordingBlock Controllers
    Get.put(UpdateBlockNameController());
    Get.put(HideBlockController());
    Get.put(DeleteBlockController());
    Get.put(CreateBlockController());

    ///* Initialize Icon Controllers
    Get.put(IconBlockController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: dark ? TColors.dark : TColors.light,
        appBar: TAppBar(
          title: Text(
            "Customize recording page",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
          centerTitle: true,
          bottom: TTabBar(
            tabs: [
              Tab(text: "Active blocks"),
              Tab(text: "Hidden blocks"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ///* Active blocks tab
            TActiveBlockTab(),

            ///* Hidden blocks tab
            THiddenBlockTab(),
          ],
        ),
      ),
    );
  }
}

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
                  (_) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: TSizes.spaceBtwSections / 2),
                    child: const TShimmerEffect(
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
                      (_) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: TSizes.spaceBtwSections / 2),
                        child: const TShimmerEffect(
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

class TNotesBlockCustomize extends StatelessWidget {
  const TNotesBlockCustomize({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final block = RecordingBlockController.instance.recordingBlocks
        .firstWhere((block) => block.id == 'notes');

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
                    "Today's Notes",
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
                    icon: Icon(Iconsax.more, size: TSizes.iconSm),
                  ),
                  IconButton(
                    onPressed: () {}, // Expand/collapse
                    icon: Icon(Iconsax.arrow_down_1, size: TSizes.iconSm),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          ///* Text field for notes
          Form(
            child: TextFormField(
              enabled: false,
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
                    icon: Icon(Iconsax.more, size: TSizes.iconSm),
                  ),
                  IconButton(
                    onPressed: () {}, // Expand/collapse
                    icon: Icon(Iconsax.arrow_down_1, size: TSizes.iconSm),
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

class TCustomizeRecordingBlock extends StatelessWidget {
  final RecordingBlockModel block;

  const TCustomizeRecordingBlock({
    super.key,
    required this.block,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final updateCtrl = UpdateBlockNameController.instance;
    return TRoundedContainer(
      backgroundColor: dark ? TColors.textPrimary : TColors.white,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Block title
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
                  ///* Show menu
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
                              if (!isSpecial)
                                ListTile(
                                  leading: const Icon(
                                    Iconsax.trash,
                                    color: TColors.error,
                                  ),
                                  title: const Text(
                                    "Delete Block",
                                    style: TextStyle(
                                      color: TColors.error,
                                    ),
                                  ),
                                  onTap: () {
                                    Get.back(); // Close context menu or bottom sheet

                                    Get.dialog(
                                      TDialog(block: block),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: Icon(Iconsax.more, size: TSizes.iconSm),
                  ),

                  ///* Expand/collapse
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Iconsax.arrow_down_1, size: TSizes.iconSm),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          ///* Block icons
          Wrap(
            spacing: TSizes.spaceBtwItems,
            runSpacing: TSizes.spaceBtwItems,
            children: [
              for (final icon in block.icons)
                TCustomizeRecordingIcon(icon: icon, blockId: block.id),
              TAddIconButton(blockId: block.id), // Add Icon button at the end
            ],
          ),
        ],
      ),
    );
  }
}

class TDialog extends StatelessWidget {
  const TDialog({
    super.key,
    required this.block,
  });

  final RecordingBlockModel block;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Dialog(
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
              "Delete Block?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              "This will permanently delete the block and all related records.",
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
                      side: BorderSide(
                        color: TColors.error,
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog
                      DeleteBlockController.instance.deleteBlock(block.id);
                    },
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    final controller = TextEditingController(text: icon.label);
    final dark = THelperFunctions.isDarkMode(context);
    final iconCtrl = IconBlockController.instance;
    iconCtrl.setTempIconPath(icon.iconPath);
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon.label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Icon with overlays pencil
          GestureDetector(
            ///TODO: Add icon picker using TPredefinedIconPicker
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
                  Positioned(
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

          /// Rename icon field
          TextFormField(
            controller: controller,
            maxLength: 12,
            decoration: const InputDecoration(labelText: "Rename icon"),
          ),
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
                                        side: BorderSide(
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

              /// Save rename
              Expanded(
                child: TextButton(
                  onPressed: () {
                    final newLabel = controller.text.trim();
                    if (newLabel.isNotEmpty) {
                      IconBlockController.instance.updateIconLabel(
                        blockId,
                        icon.id,
                        newLabel,
                      );
                    }
                    iconCtrl.resetTempIconPath(); // ✅ Clean up
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

class TAddIconButton extends StatelessWidget {
  final String blockId;

  const TAddIconButton({super.key, required this.blockId});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<IconMetadata>(
          backgroundColor: dark ? TColors.dark : TColors.white,
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TSizes.cardRadiusLg),
            ),
          ),
          builder: (_) => const TPredefinedIconPicker(),
        ).then((selectedIcon) {
          if (selectedIcon != null) {
            final controller = TextEditingController();
            final formKey = GlobalKey<FormState>();

            showModalBottomSheet(
              backgroundColor: dark ? TColors.dark : TColors.white,
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => TBottomDialog(
                title: "Label Icon",
                controller: controller,
                formKey: formKey,
                maxLength: 12,
                hintText: "e.g. Excited",
                onConfirm: () {
                  if (formKey.currentState!.validate()) {
                    final label = controller.text.trim();

                    IconBlockController.instance.addIconToBlock(
                      blockId,
                      selectedIcon,
                      label,
                    );
                    Get.back(); // Close dialog
                  }
                },
              ),
            );
          }
        });
      },
      child: Column(
        children: [
          TRoundedContainer(
            width: 48,
            height: 48,
            radius: 24,
            backgroundColor: TColors.primary.withOpacity(0.1),
            child: Icon(Iconsax.add, color: TColors.primary),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            "Add icon",
            style: Theme.of(context).textTheme.labelSmall!.apply(
                  color: TColors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class TPredefinedIconPicker extends StatelessWidget {
  const TPredefinedIconPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = getIconCategories();
    final dark = THelperFunctions.isDarkMode(context);
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: DefaultTabController(
        length: categories.length,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select an icon",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TTabBar(
                backgroundColor: TColors.white,
                tabs: categories.map((c) {
                  return Tab(text: iconCategoryToString(c));
                }).toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Expand TabBarView to fill available space
              Expanded(
                child: TabBarView(
                  children: categories.map((category) {
                    final icons = getIconsByCategory(category);
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: icons.length,
                      itemBuilder: (_, idx) {
                        final iconMeta = icons[idx];
                        return GestureDetector(
                          onTap: () {
                            Get.back(result: iconMeta);
                          },
                          child: TRoundedContainer(
                            padding: EdgeInsets.all(TSizes.xs),
                            width: 60,
                            height: 60,
                            radius: 30,
                            backgroundColor:
                                dark ? TColors.white : TColors.light,
                            child: Padding(
                              padding: const EdgeInsets.all(TSizes.xs),
                              child: Image.asset(
                                iconMeta.iconPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
