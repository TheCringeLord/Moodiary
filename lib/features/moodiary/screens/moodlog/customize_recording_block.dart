import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/appbar/appbar.dart';

import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/custom_shape/container/rounded_container.dart';

import '../../controllers/recording_block_controller.dart';
import '../../models/recording_block_model.dart';
import '../../models/recording_icon_mode.dart';

class CustomizeRecordingBlockScreen extends StatelessWidget {
  const CustomizeRecordingBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    Get.put(RecordingBlockController());
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

        ///* Done Button Click to save mood log
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Save Changes"),
          ),
        ),
      ),
    );
  }
}

class THiddenBlockTab extends StatelessWidget {
  const THiddenBlockTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///* Hidden blocks list
          ],
        ),
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
            // … your “Create new block” button …
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
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

            // ← Dynamic list of active blocks
            Obx(() => Column(
                  children: [
                    for (final block
                        in RecordingBlockController.instance.activeBlocks) ...[
                      TCustomizeRecordingBlock(block: block),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ],
                )),
          ],
        ),
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
                    onPressed: () {}, // Edit block name
                    icon: Icon(Iconsax.edit, size: TSizes.iconSm),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {}, // Show menu
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

          /// Block icons
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
            child: Image.asset(
              icon.iconPath,
              width: size / 2,
              height: size / 2,
              fit: BoxFit.contain,
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
          Text("Add icon", style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
