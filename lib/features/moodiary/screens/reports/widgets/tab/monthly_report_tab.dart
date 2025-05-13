import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/features/moodiary/controllers/report_controller.dart';

import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/frequently_recorded/frequently_recorded.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/mood_bar/mood_bar.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/mood_flow/mood_flow.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/sleep_analysis/sleep_analysis.dart';
import 'package:moodiary/utils/constants/sizes.dart';

class TMonthlyReportTab extends StatelessWidget {
  const TMonthlyReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reportCtrl = ReportController.instance;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            ///* Month Picker
            Obx(() {
              return GestureDetector(
                onTap: () => reportCtrl.openMonthPicker(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      reportCtrl.currentMonthLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: TSizes.xs),
                    const Icon(
                      Iconsax.arrow_down_1,
                      size: TSizes.iconSm,
                    )
                  ],
                ),
              );
            }),
            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Mood Flow Chart
            const TMoodFlow(),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Mood bar
            const TMoodBar(),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Frequently Recorded Icons
            const TFrequentlyRecorded(),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Sleep Analysis
            const TSleepAnalysis(),
          ],
        ),
      ),
    );
  }
}
