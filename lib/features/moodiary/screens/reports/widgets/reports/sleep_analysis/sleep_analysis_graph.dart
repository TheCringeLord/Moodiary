import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/report_controller.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
