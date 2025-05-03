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
import '../../../../utils/loaders/shimmer_effect.dart';
import '../../controllers/CRUD_recording_block/create_block_controller.dart';
import '../../controllers/recording_block_controller.dart';
import '../../controllers/CRUD_recording_block/update_block_name_controller.dart';
import '../../models/recording_block_model.dart';
import '../../models/recording_icon_mode.dart';

class CustomizeRecordingBlockScreen extends StatelessWidget {
  const CustomizeRecordingBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    Get.put(UpdateBlockNameController());
    Get.put(HideBlockController());
    Get.put(DeleteBlockController());
    Get.put(CreateBlockController());

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
                      final isSpecial = block.isSpecial;
                      final isHidden = block.isHidden;

                      showModalBottomSheet(
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
                                    Get.back();
                                    Get.defaultDialog(
                                      contentPadding: const EdgeInsets.all(
                                          TSizes.defaultSpace),
                                      titlePadding: const EdgeInsets.all(
                                          TSizes.defaultSpace),
                                      title: "Confirm Delete",
                                      middleText:
                                          "Are you sure you want to delete this block?\nThis action cannot be undone.",
                                      textCancel: "Cancel",
                                      textConfirm: "Delete",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back(); // Close dialog
                                        DeleteBlockController.instance
                                            .deleteBlock(block.id);
                                      },
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
                      final isSpecial = block.isSpecial;
                      final isHidden = block.isHidden;

                      showModalBottomSheet(
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
                                    Get.back();
                                    Get.defaultDialog(
                                      contentPadding: const EdgeInsets.all(
                                          TSizes.defaultSpace),
                                      titlePadding: const EdgeInsets.all(
                                          TSizes.defaultSpace),
                                      title: "Confirm Delete",
                                      middleText:
                                          "Are you sure you want to delete this block?\nThis action cannot be undone.",
                                      textCancel: "Cancel",
                                      textConfirm: "Delete",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back(); // Close dialog
                                        DeleteBlockController.instance
                                            .deleteBlock(block.id);
                                      },
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
                                    Get.back();
                                    Get.defaultDialog(
                                      contentPadding: const EdgeInsets.all(
                                          TSizes.defaultSpace),
                                      titlePadding: const EdgeInsets.all(
                                          TSizes.defaultSpace),
                                      title: "Confirm Delete",
                                      middleText:
                                          "Are you sure you want to delete this block?\nThis action cannot be undone.",
                                      textCancel: "Cancel",
                                      textConfirm: "Delete",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back(); // Close dialog
                                        DeleteBlockController.instance
                                            .deleteBlock(block.id);
                                      },
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
    return GestureDetector(
      onTap: () {}, // Icon customization modal
      child: Column(
        children: [
          TRoundedContainer(
            width: size,
            height: size,
            radius: size / 2,
            backgroundColor: TColors.grey,
            child: Icon(
              Iconsax.gallery_edit,
              color: TColors.textPrimary,
              size: size / 2,
            ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            icon.label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: TColors.textPrimary,
                ),
          ),
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
    return GestureDetector(
      onTap: () {
        // Show modal to add icon
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
