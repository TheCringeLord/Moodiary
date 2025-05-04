import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/utils/constants/sizes.dart';

import '../../../data/repositories/mood/mood_repository.dart';
import '../models/mood_model.dart';

class ReportController extends GetxController {
  static ReportController get instance => Get.find();

  final selectedMonth = DateTime.now().obs;
  final RxList<MoodModel> moods = <MoodModel>[].obs;
  final RxList<FlSpot> spots = <FlSpot>[].obs;

  Future<void> loadMonthlyMoodLogs(DateTime month) async {
    selectedMonth.value = month;
    final moodList = await MoodRepository.instance.getMoodsByMonth(month).first;
    moods.assignAll(moodList);
    final moodSpots = moodList
        .map((m) => FlSpot(m.date.day.toDouble(), m.moodScore.toDouble()))
        .toList();
    spots.assignAll(moodSpots);
  }

  ///* Month name for UI (e.g. May 2025)
  String get currentMonthLabel {
    return "${_monthName(selectedMonth.value.month)} ${selectedMonth.value.year}";
  }

  ///* List of available months from current year back to 2023
  List<DateTime> get availableMonths {
    final now = DateTime.now();
    const startYear = 2000;

    final months = <DateTime>[];
    for (int year = now.year; year >= startYear; year--) {
      for (int month = 12; month >= 1; month--) {
        final date = DateTime(year, month);
        if (date.isAfter(now)) continue;
        months.add(date);
      }
    }
    return months;
  }

  ///* Month name helper
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

  ///* Open month picker dialog
  Future<void> openMonthPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final now = DateTime.now();
        final months = availableMonths;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TSizes.spaceBtwItems),
            Text("Choose Month",
                style: Theme.of(context).textTheme.titleMedium),
            Flexible(
              child: ListView.builder(
                itemCount: months.length,
                itemBuilder: (_, index) {
                  final m = months[index];
                  final isDisabled = m.isAfter(now);
                  return ListTile(
                    enabled: !isDisabled,
                    title: Text(
                      "${_monthName(m.month)} ${m.year}",
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    onTap: isDisabled ? null : () => Navigator.pop(context, m),
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      loadMonthlyMoodLogs(selected);
    }
  }
}
