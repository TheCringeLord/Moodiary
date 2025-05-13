import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/report_controller.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
