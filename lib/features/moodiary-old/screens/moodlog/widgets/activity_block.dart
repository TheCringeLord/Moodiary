import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary-old/screens/moodlog/widgets/activity_icon.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../controllers/mood_log_controller.dart';
import '../../../models/activity_model.dart';

class TActivityBlock extends StatelessWidget {
  const TActivityBlock({
    super.key,
    required this.title,
    required this.icons,
    this.isCollapsible = true,
    this.isCustomizable = true,
    this.isCustomizationMode = false, // Add this flag
    this.onTitleEdit,
    this.onDelete,
    this.onVisibilityToggle,
  });

  final String title;
  final List<ActivityIcon> icons;
  final bool isCollapsible;
  final bool isCustomizable;
  final bool
      isCustomizationMode; // New flag to determine if we're in customization mode
  final Function(String)? onTitleEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onVisibilityToggle;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoodlogController>();

    return Obx(() {
      final isExpanded = controller.expandedCategories.contains(title);

      return Padding(
        padding: const EdgeInsets.only(top: TSizes.spaceBtwSections),
        child: TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.dark
              : TColors.white,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title, optional edit icon, collapse button, and optional menu button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title with optional edit pencil icon
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        // Only show pencil icon in customization mode
                        if (isCustomizationMode && isCustomizable)
                          IconButton(
                            icon: const Icon(Iconsax.edit, size: 18),
                            onPressed: () => _showEditTitleDialog(context),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (isCollapsible)
                        IconButton(
                          icon: Icon(
                              isExpanded
                                  ? Iconsax.arrow_up_2
                                  : Iconsax.arrow_down_1,
                              size: 20),
                          onPressed: () => controller.toggleCategory(title),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      // Only show 3-dot menu in customization mode
                      if (isCustomizationMode && isCustomizable)
                        IconButton(
                          icon: const Icon(Iconsax.more, size: 20),
                          onPressed: () => _showOptionsBottomSheet(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ],
              ),

              // Icons grid (shown if expanded or not collapsible)
              if (!isCollapsible || isExpanded)
                Column(
                  children: [
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Wrap(
                      spacing: TSizes.spaceBtwItems,
                      runSpacing: TSizes.spaceBtwItems,
                      alignment: WrapAlignment.start,
                      children: [
                        ...icons
                            .map((icon) => TActivityIcon(
                                  icon: icon,
                                  categoryName: title,
                                ))
                            .toList(),

                        // Only show add icon button in customization mode
                        if (isCustomizationMode && isCustomizable)
                          _buildAddIconButton(context),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAddIconButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddIconDialog(context),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: TColors.grey),
          color: Colors.transparent,
        ),
        child: const Icon(Icons.add, color: TColors.grey),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: THelperFunctions.isDarkMode(context)
              ? TColors.dark
              : TColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(TSizes.cardRadiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bottom sheet handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TColors.grey,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Edit option
            ListTile(
              leading: const Icon(Iconsax.edit),
              title: const Text("Edit block name"),
              onTap: () {
                Get.back();
                _showEditTitleDialog(context);
              },
            ),

            // Hide/Show option
            ListTile(
              leading: const Icon(Iconsax.eye_slash),
              title: const Text("Hide from recording page"),
              onTap: () {
                Get.back();
                if (onVisibilityToggle != null) onVisibilityToggle!();
              },
            ),

            // Delete option
            ListTile(
              leading: const Icon(Iconsax.trash, color: TColors.error),
              title:
                  const Text("Delete", style: TextStyle(color: TColors.error)),
              onTap: () {
                Get.back();
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showEditTitleDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: title);

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Block Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter block name",
          ),
          maxLength: 14, // Limit to 14 characters
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty && newTitle != title) {
                if (onTitleEdit != null) onTitleEdit!(newTitle);
              }
              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAddIconDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("Add Custom Icon"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose icon type:"),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconTypeOption(context, "Upload Image", Iconsax.image),
                  _buildIconTypeOption(
                      context, "Choose Icon", Iconsax.emoji_happy),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Widget _buildIconTypeOption(
      BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Get.back();
        // Handle icon type selection
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: TColors.primary),
          ),
          const SizedBox(height: TSizes.xs),
          Text(title, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Block"),
        content: const Text(
            "Are you sure you want to delete this block? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (onDelete != null) onDelete!();
            },
            style: TextButton.styleFrom(foregroundColor: TColors.error),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
