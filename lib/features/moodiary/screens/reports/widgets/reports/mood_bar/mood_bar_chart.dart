import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/report_controller.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
