import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/appbar/tabbar.dart';
import 'package:moodiary/utils/constants/sizes.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/popups/loaders.dart';
import '../../controllers/activity_customization_controller.dart';

import '../../models/activity_model.dart';
import 'widgets/activity_block.dart';

class CustomizeActivityScreen extends StatelessWidget {
  const CustomizeActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityCustomizationController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            // Active blocks tab
            _buildActiveBlocksTab(controller, context),

            // Hidden blocks tab
            _buildHiddenBlocksTab(controller, context),
          ],
        ),
        bottomNavigationBar: Obx(() => controller.hasUnsavedChanges.value
            ? _buildSaveChangesBar(context, controller)
            : const SizedBox.shrink()),
      ),
    );
  }

  Widget _buildActiveBlocksTab(
      ActivityCustomizationController controller, BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // Create new block button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showCreateBlockDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: THelperFunctions.isDarkMode(context)
                          ? TColors.textPrimary
                          : const Color.fromARGB(255, 229, 239, 250),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.add,
                          color: THelperFunctions.isDarkMode(context)
                              ? TColors.white
                              : TColors.primary,
                        ),
                        const SizedBox(width: TSizes.sm),
                        Text(
                          "Create new block",
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                                color: THelperFunctions.isDarkMode(context)
                                    ? TColors.white
                                    : TColors.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                // List of visible activity blocks
                ...controller.getVisibleCategories().map(
                      (category) => TActivityBlock(
                        title: category['title'],
                        icons: List<ActivityIcon>.from(
                            category['icons'] as List), // ← List<dynamic>
                        isCustomizable: true,
                        isCustomizationMode: true,
                        onTitleEdit: (newTitle) => controller
                            .updateCategoryTitle(category['id'], newTitle),
                        onDelete: () =>
                            controller.deleteCategory(category['id']),
                        onVisibilityToggle: () =>
                            controller.toggleCategoryVisibility(category['id']),
                      ),
                    ),

                if (controller.getVisibleCategories().isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.defaultSpace),
                      child: Text(
                          "No visible blocks. Unhide blocks from the Hidden tab."),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildHiddenBlocksTab(
      ActivityCustomizationController controller, BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // List of hidden activity blocks
                ...controller.getHiddenCategories().map(
                      (category) => TActivityBlock(
                        title: category['title'],
                        icons:
                            List<ActivityIcon>.from(category['icons'] as List),
                        isCustomizable: true,
                        isCustomizationMode: true,
                        onTitleEdit: (newTitle) => controller
                            .updateCategoryTitle(category['id'], newTitle),
                        onDelete: () =>
                            controller.deleteCategory(category['id']),
                        onVisibilityToggle: () =>
                            controller.toggleCategoryVisibility(category['id']),
                      ),
                    ),

                if (controller.getHiddenCategories().isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.defaultSpace),
                      child: Text("No hidden blocks"),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSaveChangesBar(
    BuildContext context,
    ActivityCustomizationController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      color:
          THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.saveChanges();
                TLoaders.successSnackBar(
                  title: "Success",
                  message: "Changes saved successfully!",
                );
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.white,
              ),
              child: const Text("Save Changes"),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateBlockDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Create New Block"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter block name",
          ),
          maxLength: 14,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                ActivityCustomizationController.instance
                    .createNewCategory(title);
                Get.back();
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
