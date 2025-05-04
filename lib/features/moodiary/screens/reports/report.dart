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
import '../../controllers/report_controller.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final reportCtrl = Get.put(ReportController());
    reportCtrl.loadMonthlyMoodLogs(DateTime(2025, 5));
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
          bottom: TTabBar(
            tabs: [
              Tab(text: "Monthly"),
              Tab(text: "Annual"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ///* Active blocks tab
            TMonthlyReportTab(),

            ///* Hidden blocks tab
            TMonthlyReportTab(),
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
    final dark = THelperFunctions.isDarkMode(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            ///* Month Picker
            Obx(() {
              final month = reportCtrl.selectedMonth.value;
              final monthLabel = "${_monthName(month.month)} ${month.year}";

              return GestureDetector(
                onTap: () => reportCtrl.openMonthPicker(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: TSizes.xs),
                    Icon(
                      Iconsax.arrow_down_1,
                      size: TSizes.iconSm,
                    )
                  ],
                ),
              );
            }),
            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Mood Flow Chart
            TRoundedContainer(
              backgroundColor: dark ? TColors.textPrimary : TColors.white,
              width: double.infinity,
              padding: EdgeInsets.all(TSizes.spaceBtwItems),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Mood Flow",
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TMoodFlowChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}

class TMoodFlowChart extends StatelessWidget {
  const TMoodFlowChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReportController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    // Mood icon and color maps
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
      final moodSpots = controller.spots;

      return SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 32,
            minY: 0.5,
            maxY: 5.5,
            clipData: FlClipData.none(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: false,
              verticalInterval: 5,
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
                    final int day = value.toInt();
                    if ([1, 6, 11, 16, 21, 26, 31].contains(day)) {
                      final month = controller.selectedMonth.value.month;
                      return Padding(
                        padding: const EdgeInsets.only(top: 6, right: 15),
                        child: Center(
                          child: Text("$month/$day",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall),
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
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: moodSpots,
                isCurved: false,
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
}
