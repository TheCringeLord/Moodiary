import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';

import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../controllers/recording_block_controller.dart';
import '../../controllers/report_controller.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    Get.put(ReportController());
    Get.put(RecordingBlockController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: dark ? TColors.dark : TColors.light,
        appBar: TAppBar(
          title: Text(
            "Report",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          centerTitle: true,
          bottom: const TTabBar(
            tabs: [
              Tab(text: "Monthly"),
              Tab(text: "Annual"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ///* Active blocks tab
            TMonthlyReportTab(),

            ///* Hidden blocks tab
            TAnnualReportTab(),
          ],
        ),
      ),
    );
  }
}

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

class TSleepAnalysisGraph extends StatelessWidget {
  const TSleepAnalysisGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReportController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final isAnnualView = DefaultTabController.of(context).index == 1;

    return Obx(() {
      // Use appropriate date source based on view
      final DateTime selectedDate;
      final List moodList;

      if (isAnnualView) {
        selectedDate = DateTime(controller.selectedYear.value, 1, 1);
        moodList = controller.annualMoods;
      } else {
        selectedDate = controller.selectedMonth.value;
        moodList = controller.moods;
      }

      // Calculate appropriate x-axis range
      final int xAxisMax = isAnnualView
          ? 12 // Months in a year
          : DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);

      final sleepList = moodList
          .where((m) => m.sleepStart != null && m.sleepEnd != null)
          .toList();

      if (sleepList.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text("No sleep data",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        );
      }

      // Determine if we're showing monthly or annual sleep chart
      if (isAnnualView) {
        return _buildAnnualSleepChart(context, sleepList, xAxisMax, dark);
      } else {
        return _buildMonthlySleepChart(
            context, sleepList, selectedDate, xAxisMax, dark);
      }
    });
  }

  // Monthly sleep chart (days of month)
  Widget _buildMonthlySleepChart(BuildContext context, List sleepList,
      DateTime selectedMonth, int daysInMonth, bool dark) {
    

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          minY: 0,
          maxY: 24,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 4,
            getDrawingHorizontalLine: (y) => FlLine(
              color: dark
                  ? TColors.textSecondary.withAlpha(120)
                  : TColors.grey.withAlpha(120),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: dark
                    ? TColors.textSecondary.withAlpha(120)
                    : TColors.grey.withAlpha(120),
              )),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 58,
                getTitlesWidget: (value, _) {
                  final day = value.toInt();
                  final baseTicks = [1, 6, 11, 16, 21];
                  final ticks = [
                    ...baseTicks,
                    if (daysInMonth >= 30) 26,
                    daysInMonth,
                  ];
                  if (ticks.contains(day)) {
                    final month = selectedMonth.month;
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "$month/$day",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            // Other titles code remains unchanged...
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 6,
                reservedSize: 58,
                getTitlesWidget: (value, _) {
                  final hour = value.toInt();
                  if (hour % 6 != 0 || hour > 24) {
                    return const SizedBox.shrink();
                  }
                  String label;
                  if (hour == 0 || hour == 24) {
                    label = '12AM';
                  } else if (hour < 12) {
                    label = '${hour}AM';
                  } else if (hour == 12) {
                    label = '12PM';
                  } else {
                    label = '${hour - 12}PM';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: TSizes.xs),
                    child: Text(label,
                        style: Theme.of(context).textTheme.labelMedium),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barTouchData: BarTouchData(enabled: false),
          // Generate bars for each day
          barGroups: List.generate(daysInMonth, (index) {
            final day = index + 1;
            final mood = sleepList.firstWhereOrNull((m) => m.date.day == day);

            // Rest of your bar chart code remains unchanged...
            if (mood == null) {
              return BarChartGroupData(x: day, barRods: []);
            }

            final start = mood.sleepStart!;
            final end = mood.sleepEnd!;

            double startHour = start.hour + start.minute / 60.0;
            double endHour = end.hour + end.minute / 60.0;

            if (endHour < startHour) endHour += 24;
            final duration = endHour - startHour;

            final displayStart = startHour % 24;
            final displayEnd = endHour % 24;

            Color barColor;
            if (duration < 6) {
              barColor = const Color(0xFF7B61FF);
            } else if (duration <= 8) {
              barColor = const Color(0xFF6D9EFF);
            } else {
              barColor = const Color(0xFF9CD1FF);
            }

            return BarChartGroupData(
              x: day,
              barRods: [
                BarChartRodData(
                  fromY: displayStart,
                  toY: displayEnd,
                  width: 6,
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Annual sleep chart (months of year)
  Widget _buildAnnualSleepChart(
      BuildContext context, List sleepList, int monthsCount, bool dark) {
 
 

    // Group sleep data by month and calculate average duration per month
    final Map<int, List<double>> sleepDurationsByMonth = {};

    // Initialize all months
    for (int i = 1; i <= 12; i++) {
      sleepDurationsByMonth[i] = [];
    }

    // Gather all sleep durations for each month
    for (final mood in sleepList) {
      final month = mood.date.month;
      final start = mood.sleepStart!;
      final end = mood.sleepEnd!;

      double startHour = start.hour + start.minute / 60.0;
      double endHour = end.hour + end.minute / 60.0;

      if (endHour < startHour) endHour += 24; // handle overnight
      final duration = endHour - startHour;

      sleepDurationsByMonth[month]?.add(duration);
    }

    // Calculate average durations
    final Map<int, double> avgDurations = {};
    sleepDurationsByMonth.forEach((month, durations) {
      if (durations.isNotEmpty) {
        final total = durations.reduce((a, b) => a + b);
        avgDurations[month] = total / durations.length;
      } else {
        avgDurations[month] = 0; // No sleep data for this month
      }
    });

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          minY: 0,
          maxY: 12, // Maximum hours to display
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (y) => FlLine(
              color: dark
                  ? TColors.textSecondary.withAlpha(120)
                  : TColors.grey.withAlpha(120),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: dark
                  ? TColors.textSecondary.withAlpha(120)
                  : TColors.grey.withAlpha(120),
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 58,
                getTitlesWidget: (value, _) {
                  final month = value.toInt();
                  if (month >= 1 && month <= 12) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _getMonthAbbr(month),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                reservedSize: 58,
                getTitlesWidget: (value, _) {
                  final hour = value.toInt();
                  if (hour % 2 != 0 || hour > 12) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: TSizes.xs),
                    child: Text("${hour}h",
                        style: Theme.of(context).textTheme.labelMedium),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final month = group.x;
                final avg = avgDurations[month] ?? 0;
                if (avg == 0) return null;

                final hours = avg.floor();
                final minutes = ((avg - hours) * 60).round();
                return BarTooltipItem(
                  '${hours}h ${minutes}m',
                  Theme.of(context).textTheme.labelMedium!,
                );
              },
            ),
          ),
          barGroups: List.generate(12, (index) {
            final month = index + 1;
            final avgDuration = avgDurations[month] ?? 0;

            // If no data, return empty bar
            if (avgDuration == 0) {
              return BarChartGroupData(x: month, barRods: []);
            }

            // Color coding based on average sleep duration
            Color barColor;
            if (avgDuration < 6) {
              barColor = const Color(0xFF7B61FF);
            } else if (avgDuration <= 8) {
              barColor = const Color(0xFF6D9EFF);
            } else {
              barColor = const Color(0xFF9CD1FF);
            }

            return BarChartGroupData(
              x: month,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: avgDuration,
                  width: 8,
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Helper method to get month abbreviation
  String _getMonthAbbr(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}

class TSleepHourDuration extends StatelessWidget {
  const TSleepHourDuration({
    super.key,
    required this.text,
    required this.color,
    required this.totalDay,
    required this.dayInMonth,
  });

  final String text;
  final Color color;
  final String totalDay;
  final String dayInMonth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              height: 20,
              width: 20,
              radius: TSizes.cardRadiusXs,
              backgroundColor: color,
            ),
            const SizedBox(width: TSizes.sm),
            Text(text, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
            child: Divider(
              color: TColors.grey.withAlpha(100),
              height: TSizes.sm,
              thickness: 1,
            ),
          ),
        ),
        Row(
          children: [
            Text(totalDay, style: Theme.of(context).textTheme.labelSmall),
            Text(
              " / $dayInMonth",
              style: Theme.of(context).textTheme.labelSmall!.apply(
                    color: TColors.darkGrey,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

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

class TFrequentlyIcon extends StatelessWidget {
  final int rank;
  final String iconPath;
  final String label;
  final int count;
  final bool isPlaceholder;

  const TFrequentlyIcon({
    super.key,
    required this.rank,
    required this.iconPath,
    required this.label,
    required this.count,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ///* Card
            TRoundedContainer(
              backgroundColor: dark ? TColors.dark : TColors.light,
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///* Icon
                  TRoundedContainer(
                    width: 60,
                    height: 60,
                    radius: 60 / 2,
                    backgroundColor: dark ? TColors.lightGrey : TColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.iconXs),
                      child: isPlaceholder
                          ? Icon(Iconsax.gallery,
                              size: 30,
                              color: dark ? TColors.darkGrey : TColors.grey)
                          : Image.asset(
                              iconPath,
                              width: 60,
                              height: 60,
                            ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  ///* Label
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  ///* Count
                  Text(
                    "x$count",
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            ///* Rank Badge
            Positioned(
              top: 9,
              left: 14,
              child: Text(
                "$rank",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TMoodBar extends StatelessWidget {
  const TMoodBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      backgroundColor: dark ? TColors.textPrimary : TColors.white,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text("Mood Bar", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const TMoodBarChart(),
        ],
      ),
    );
  }
}

class TMoodBarChart extends StatelessWidget {
  const TMoodBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReportController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final isAnnualView = DefaultTabController.of(context).index == 1;

    return Obx(() {
      // Use appropriate mood data based on context
      final moods = isAnnualView ? controller.annualMoods : controller.moods;
      final total = moods.length;

      final moodIcons = {
        'veryHappy': TImages.veryHappy,
        'happy': TImages.happy,
        'neutral': TImages.neutral,
        'unhappy': TImages.unHappy,
        'sad': TImages.sad,
      };

      final segmentColors = {
        'veryHappy': const Color.fromARGB(255, 54, 192, 125),
        'happy': const Color.fromARGB(255, 118, 226, 230),
        'neutral': const Color.fromARGB(255, 255, 206, 59),
        'unhappy': const Color.fromARGB(255, 243, 160, 66),
        'sad': const Color.fromARGB(255, 233, 112, 112),
      };

      // Initialize counts and percentages
      final counts = <String, int>{};
      final moodKeys = moodIcons.keys.toList();
      for (var key in moodKeys) {
        counts[key] = 0;
      }

      for (final m in moods) {
        counts[m.mainMood] = (counts[m.mainMood] ?? 0) + 1;
      }

      final percentages =
          counts.map((k, v) => MapEntry(k, total > 0 ? v / total : 0.0));

      // Find the mood with the highest percentage
      final double maxPct =
          percentages.values.fold(0.0, (prev, v) => v > prev ? v : prev);
      final highestMoods = percentages.entries
          .where((entry) => entry.value == maxPct && maxPct > 0)
          .map((entry) => entry.key)
          .toSet();

      // Build segments
      const totalFlex = 1000;
      final segments = moodKeys.map((key) {
        final pct = percentages[key]!;
        final flex = (pct * totalFlex).round();
        final color = pct > 0 ? segmentColors[key]! : Colors.grey.shade400;

        return Expanded(
          flex: flex > 0 ? flex : 1,
          child: Container(
            height: 40,
            color: color,
          ),
        );
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icons and percentage labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moodKeys.map((key) {
              final pct = (percentages[key]! * 100).round();
              final isZero = pct == 0;
              final isMax = highestMoods.contains(key);

              return Column(
                children: [
                  ClipOval(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isZero ? Colors.grey : Colors.transparent,
                        BlendMode.saturation,
                      ),
                      child:
                          Image.asset(moodIcons[key]!, width: 50, height: 50),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TRoundedContainer(
                    width: 50,
                    backgroundColor: isMax
                        ? segmentColors[key]!.withAlpha(50)
                        : dark
                            ? const Color.fromARGB(255, 76, 78, 100)
                            : TColors.grey,
                    child: Center(
                      child: Text(
                        "$pct%",
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                              color: isMax
                                  ? segmentColors[key]!
                                  : dark
                                      ? const Color.fromARGB(255, 138, 143, 163)
                                      : TColors.darkGrey,
                            ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          // Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(children: segments),
          ),
        ],
      );
    });
  }
}

class TMoodFlow extends StatelessWidget {
  const TMoodFlow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      backgroundColor: dark ? TColors.textPrimary : TColors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          Row(
            children: [
              Text("Mood Flow", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const TMoodFlowChart(),
        ],
      ),
    );
  }
}

class TMoodFlowChart extends StatelessWidget {
  const TMoodFlowChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReportController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final isAnnualView = DefaultTabController.of(context).index == 1;

    // Different color schemes for mood dots
    final moodColors = {
      5: Colors.greenAccent.shade100,
      4: Colors.lightBlueAccent,
      3: Colors.amber,
      2: Colors.deepOrange.shade300,
      1: Colors.redAccent,
    };

    final moodIcons = {
      5: TImages.veryHappy,
      4: TImages.happy,
      3: TImages.neutral,
      2: TImages.unHappy,
      1: TImages.sad,
    };

    return Obx(() {
      // Use annual data when in annual view
      final moodSpots = isAnnualView
          ? controller.annualSpots // Monthly averages for annual view
          : controller.spots;

      // Calculate display parameters based on context
      final xAxisMax = isAnnualView
          ? 12.0 // 12 months for annual view
          : DateUtils.getDaysInMonth(controller.selectedMonth.value.year,
              controller.selectedMonth.value.month);

      if (moodSpots.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text("No data to show",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        );
      }

      return SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            minX: isAnnualView ? 1 : 1,
            maxX: xAxisMax.toDouble(),
            minY: 0.5,
            maxY: 5.5,
            clipData: const FlClipData.none(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: false,
              verticalInterval: isAnnualView ? 1 : 5,
              getDrawingVerticalLine: (value) => FlLine(
                color: dark
                    ? TColors.textSecondary.withAlpha(120)
                    : TColors.grey.withAlpha(120),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 32,
                  getTitlesWidget: (value, _) {
                    final int xValue = value.toInt();

                    if (isAnnualView) {
                      // For annual view, show month names
                      if (xValue >= 1 && xValue <= 12) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Center(
                            child: Text(
                              _getMonthAbbr(xValue),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        );
                      }
                    } else {
                      // Monthly view labels
                      final int day = xValue;
                      final baseTicks = [1, 6, 11, 16, 21];
                      final ticks = [
                        ...baseTicks,
                        if (xAxisMax >= 30) 26,
                        xAxisMax.toInt(),
                      ];

                      if (ticks.contains(day)) {
                        final month = controller.selectedMonth.value.month;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6, right: 15),
                          child: Center(
                            child: Text("$month/$day",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium),
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              // Rest of your titles configuration
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, _) {
                    if (value % 1 != 0 || value < 1 || value > 5) {
                      return const SizedBox.shrink();
                    }
                    final path = moodIcons[value.toInt()];
                    if (path == null) return const SizedBox.shrink();
                    return Image.asset(path, width: 24, height: 24);
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: moodSpots,
                isCurved: true,
                color: dark
                    ? const Color.fromARGB(255, 44, 221, 192)
                    : Colors.blue.shade100,
                barWidth: 2,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, _, __, ___) {
                    final color = moodColors[spot.y.toInt()] ?? Colors.white;
                    return FlDotCirclePainter(
                      radius: 3,
                      color: color,
                      strokeWidth: 1,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: dark
                      ? TColors.darkLinearGradient
                      : TColors.lightLinearGradient,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Helper function to get month abbreviation
  String _getMonthAbbr(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}
