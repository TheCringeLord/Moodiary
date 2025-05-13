import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/report_controller.dart';

import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/frequently_recorded/frequently_icon.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TFrequentlyRecorded extends StatelessWidget {
  const TFrequentlyRecorded({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReportController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final isAnnualView = DefaultTabController.of(context).index == 1;

    return Obx(() {
      // Use appropriate data source
      final items = isAnnualView
          ? controller.mostFrequentIconsFromAnnual
          : controller.mostFrequentIcons;

      // Ensure 3 entries (fill with nulls if less)
      final padded =
          List.generate(3, (i) => i < items.length ? items[i] : null);
      final hasData = items.isNotEmpty;
      final topLabel = hasData ? items.first.key.label : "Icon";

      return TRoundedContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        backgroundColor: dark ? TColors.textPrimary : TColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Frequently Recorded",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///* Top 3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                final entry = padded[index];
                return TFrequentlyIcon(
                  rank: index + 1,
                  iconPath: entry?.key.iconPath ?? '',
                  label: entry?.key.label ?? "Icon",
                  count: entry?.value ?? 0,
                  isPlaceholder: entry == null,
                );
              }),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Summary
            Center(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineSmall,
                  children: [
                    const TextSpan(text: 'You recorded this '),
                    TextSpan(
                      text: topLabel,
                      style: const TextStyle(
                        color: TColors.primary,
                      ),
                    ),
                    const TextSpan(text: ' the most'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
