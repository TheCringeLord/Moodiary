import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/report_controller.dart';

import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/sleep_analysis/sleep_analysis_graph.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/sleep_analysis/sleep_hour_duration.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TSleepAnalysis extends StatelessWidget {
  const TSleepAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final reportCtrl = ReportController.instance;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      backgroundColor: dark ? TColors.textPrimary : TColors.white,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text("Sleep Analysis",
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          
          Obx(
            () {
              final bedtime = reportCtrl.avgBedtime.value;
              final wakeUp = reportCtrl.avgWakeUp.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TRoundedContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                      backgroundColor:
                          dark ? TColors.textPrimary : TColors.white,
                      showBorder: true,
                      borderColor: dark ? TColors.textSecondary : TColors.grey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bedtime",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            bedtime != null ? bedtime.format(context) : "--:--",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TRoundedContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                      backgroundColor:
                          dark ? TColors.textPrimary : TColors.white,
                      showBorder: true,
                      borderColor: dark ? TColors.textSecondary : TColors.grey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wake Up",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            wakeUp != null ? wakeUp.format(context) : "--:--",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          ///* Sleep Graph
          const Padding(
            padding: EdgeInsets.only(right: TSizes.defaultSpace),
            child: TSleepAnalysisGraph(),
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          ///* Sleep Durations
          Obx(
            () {
              final controller = ReportController.instance;
              final isAnnualView = DefaultTabController.of(context).index == 1;

              // Select appropriate date and mood data
              final selectedDate = isAnnualView
                  ? DateTime(controller.selectedYear.value, 1, 1)
                  : controller.selectedMonth.value;
              final moods =
                  isAnnualView ? controller.annualMoods : controller.moods;

              // For annual view we count total days in year
              final int totalDays = isAnnualView
                  ? DateTime(selectedDate.year, 12, 31)
                          .difference(DateTime(selectedDate.year, 1, 1))
                          .inDays +
                      1
                  : DateUtils.getDaysInMonth(
                      selectedDate.year, selectedDate.month);

              // Filter moods with sleep data
              final sleepMoods = moods
                  .where((m) => m.sleepStart != null && m.sleepEnd != null)
                  .toList();

              // Count categories
              int lessThan6h = 0;
              int between6and8h = 0;
              int over8h = 0;

              for (var mood in sleepMoods) {
                final start = mood.sleepStart!;
                final end = mood.sleepEnd!;

                double startHour = start.hour + start.minute / 60.0;
                double endHour = end.hour + end.minute / 60.0;

                if (endHour < startHour) endHour += 24; // handle overnight
                final duration = endHour - startHour;

                if (duration < 6) {
                  lessThan6h++;
                } else if (duration <= 8) {
                  between6and8h++;
                } else {
                  over8h++;
                }
              }

              // Calculate No Record days
              final recordedDays = isAnnualView
                  ? sleepMoods
                      .map(
                          (m) => '${m.date.year}-${m.date.month}-${m.date.day}')
                      .toSet()
                      .length
                  : sleepMoods.map((m) => m.date.day).toSet().length;
              final noRecord = totalDays - recordedDays;

            

              return TRoundedContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                backgroundColor: dark ? TColors.textPrimary : TColors.white,
                showBorder: true,
                borderColor: dark ? TColors.textSecondary : TColors.grey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TSleepHourDuration(
                      text: "Less than 6h",
                      color: const Color(0xFF7B61FF),
                      totalDay: "$lessThan6h",
                      dayInMonth: "$totalDays",
                    ),
                    const SizedBox(height: TSizes.sm),
                    TSleepHourDuration(
                      text: "6 - 8h",
                      color: const Color(0xFF6D9EFF),
                      totalDay: "$between6and8h",
                      dayInMonth: "$totalDays",
                    ),
                    const SizedBox(height: TSizes.sm),
                    TSleepHourDuration(
                      text: "Over 8h",
                      color: const Color(0xFF9CD1FF),
                      totalDay: "$over8h",
                      dayInMonth: "$totalDays",
                    ),
                    const SizedBox(height: TSizes.sm),
                    TSleepHourDuration(
                      text: "No Record",
                      color: TColors.darkGrey,
                      totalDay: "$noRecord",
                      dayInMonth: "$totalDays",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
