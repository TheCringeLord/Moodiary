import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/report_controller.dart';

import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/frequently_recorded/frequently_recorded.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/mood_bar/mood_bar.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/mood_flow/mood_flow_chart.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/sleep_analysis/sleep_analysis.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TAnnualReportTab extends StatelessWidget {
  const TAnnualReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reportCtrl = ReportController.instance;

    // Load annual data when the tab is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportCtrl.loadInitialAnnualData();
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            ///* Year Picker
            Obx(() {
              return GestureDetector(
                onTap: () => reportCtrl.openYearPicker(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      reportCtrl.currentYearLabel,
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

            ///* Annual Mood Flow Chart - shows monthly averages
            TRoundedContainer(
              backgroundColor: THelperFunctions.isDarkMode(context)
                  ? TColors.textPrimary
                  : TColors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Annual Mood Trend",
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TMoodFlowChart(),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Mood distribution for the year
            const TMoodBar(),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Most frequently recorded icons for the year
            const TFrequentlyRecorded(),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Annual sleep statistics
            const TSleepAnalysis(),
          ],
        ),
      ),
    );
  }
}
