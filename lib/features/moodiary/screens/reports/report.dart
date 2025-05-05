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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
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
            const TMoodFlow(),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Mood bar
            const TMoodBar(),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Frequently Recorded Icons
            const TFrequentlyRecorded(),
          ],
        ),
      ),
    );
  }
}

class TFrequentlyRecorded extends StatelessWidget {
  const TFrequentlyRecorded({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReportController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      final items = controller.mostFrequentIcons;

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
                      style: TextStyle(
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
                          ? const Icon(Iconsax.gallery, size: 30)
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
      padding: EdgeInsets.all(TSizes.defaultSpace),
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

    return Obx(() {
      final moods = controller.moods;
      final total = moods.length;

      // Initialize counts and percentages
      final counts = <String, int>{};
      final moodKeys = moodIcons.keys.toList();
      moodKeys.forEach((key) => counts[key] = 0);

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
      padding: EdgeInsets.all(TSizes.defaultSpace),
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
