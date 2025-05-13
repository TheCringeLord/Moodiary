import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/appbar/tabbar.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/models/icon_metadata.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
                            padding: const EdgeInsets.all(TSizes.xs),
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
