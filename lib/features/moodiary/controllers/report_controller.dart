import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/utils/constants/sizes.dart';

import '../../../data/repositories/mood/mood_repository.dart';
import '../../../utils/constants/enums.dart';
import '../models/icon_metadata.dart';
import '../models/mood_model.dart';
import 'recording_block_controller.dart';

class ReportController extends GetxController {
  static ReportController get instance => Get.find();

  final selectedMonth = DateTime.now().obs;
  final RxList<MoodModel> moods = <MoodModel>[].obs;
  final RxList<FlSpot> spots = <FlSpot>[].obs;
  final Rx<TimeOfDay?> avgBedtime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> avgWakeUp = Rx<TimeOfDay?>(null);
  @override
  void onInit() {
    super.onInit();
    // whenever selectedMonth changes, reload
    ever(selectedMonth, (DateTime m) => loadMonthlyMoodLogs(m));
    // initial load
    loadMonthlyMoodLogs(selectedMonth.value);
    // Clear any previous data to prevent data leakage between users
    moods.clear();
    annualMoods.clear();
    spots.clear();
    avgBedtime.value = null;
    avgWakeUp.value = null;
  }

  Future<void> loadMonthlyMoodLogs(DateTime month) async {
    selectedMonth.value = month;
    final moodList = await MoodRepository.instance.getMoodsByMonth(month).first;
    moods.assignAll(moodList);
    spots.assignAll(moodList
        .map((m) => FlSpot(m.date.day.toDouble(), m.moodScore.toDouble())));
    calculateAverageSleepTimes(moodList);
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

  List<MapEntry<IconMetadata, int>> get mostFrequentIcons {
    // 1) Count raw icon-IDs across all logged moods
    final iconCounts = <String, int>{};
    for (final m in moods) {
      final allIds = <String>[
        ...?m.emotions,
        ...?m.weather,
        ...?m.people,
        ...?m.hobbies,
        ...?m.work,
        ...?m.health,
        ...?m.chores,
        ...?m.relationship,
        ...?m.other,
      ];
      m.customBlocks?.values.forEach(allIds.addAll);
      for (var id in allIds) {
        iconCounts[id] = (iconCounts[id] ?? 0) + 1;
      }
    }

    // 2) Take top 10 by frequency
    final sorted = iconCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(10);

    // 3) Lookup your RecordingIconModel map
    final rawMap = RecordingBlockController.instance.allIconMetadataById;

    // 4) Build IconMetadata → count map, handling missing entries
    return top.map((e) {
      final rec = rawMap[e.key];
      final meta = rec != null
          ? IconMetadata(
              id: rec.id,
              label: rec.label,
              iconPath: rec.iconPath,
              category: IconCategory.expression,
            )
          : IconMetadata(
              id: e.key,
              label: e.key,
              iconPath: '',
              category: IconCategory.expression,
            );
      return MapEntry(meta, e.value);
    }).toList();
  }

  void calculateAverageSleepTimes(List<MoodModel> moods) {
    final sleepStartTimes = moods
        .where((m) => m.sleepStart != null)
        .map((m) => m.sleepStart!)
        .toList();
    final sleepEndTimes =
        moods.where((m) => m.sleepEnd != null).map((m) => m.sleepEnd!).toList();

    if (sleepStartTimes.isNotEmpty) {
      final totalStartMinutes =
          sleepStartTimes.fold(0, (sum, dt) => sum + dt.hour * 60 + dt.minute);
      final avgStart = totalStartMinutes ~/ sleepStartTimes.length;
      avgBedtime.value = TimeOfDay(hour: avgStart ~/ 60, minute: avgStart % 60);
    }

    if (sleepEndTimes.isNotEmpty) {
      final totalEndMinutes =
          sleepEndTimes.fold(0, (sum, dt) => sum + dt.hour * 60 + dt.minute);
      final avgEnd = totalEndMinutes ~/ sleepEndTimes.length;
      avgWakeUp.value = TimeOfDay(hour: avgEnd ~/ 60, minute: avgEnd % 60);
    }
  }

  ///!------------------------------------- Annual Report -------------------------------------!///
  final RxList<MoodModel> annualMoods = <MoodModel>[].obs;
  final RxList<FlSpot> annualSpots = <FlSpot>[].obs;
  // Add a selected year observable
  final selectedYear = DateTime.now().year.obs;

  // Year label for UI (e.g. "2025")
  String get currentYearLabel => "${selectedYear.value}";

  // List of available years from current year back to 2000
  List<int> get availableYears {
    final now = DateTime.now();
    const startYear = 2000;
    return List.generate(now.year - startYear + 1, (i) => now.year - i);
  }

  // Load annual mood data
  Future<void> loadAnnualMoodLogs(int year) async {
    selectedYear.value = year;
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);

    final annualMoodList = await MoodRepository.instance
        .getMoodsByDateRange(startDate, endDate)
        .first;

    annualMoods.assignAll(annualMoodList);

    // Generate monthly average mood spots for line chart
    final monthlyAverages = <FlSpot>[];
    for (int month = 1; month <= 12; month++) {
      final monthMoods =
          annualMoodList.where((m) => m.date.month == month).toList();
      if (monthMoods.isNotEmpty) {
        final avgScore =
            monthMoods.map((m) => m.moodScore).reduce((a, b) => a + b) /
                monthMoods.length;
        monthlyAverages.add(FlSpot(month.toDouble(), avgScore));
      }
    }

    // Store in annualSpots instead of spots for annual view
    annualSpots.clear();
    annualSpots.assignAll(monthlyAverages);

    // Calculate average sleep times for the year
    calculateAverageSleepTimes(annualMoodList);
  }

  // Open year picker dialog
  Future<void> openYearPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final years = availableYears;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TSizes.spaceBtwItems),
            Text("Select Year", style: Theme.of(context).textTheme.titleMedium),
            Flexible(
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (_, index) {
                  final year = years[index];
                  return ListTile(
                    title: Text(
                      "$year",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, year),
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      loadAnnualMoodLogs(selected);
    }
  }

  // Load initial annual data
  void loadInitialAnnualData() {
    loadAnnualMoodLogs(DateTime.now().year);
  }

  List<MapEntry<IconMetadata, int>> get mostFrequentIconsFromAnnual {
    final iconCounts = <String, int>{};
    for (final m in annualMoods) {
      final allIds = <String>[
        ...?m.emotions,
        ...?m.weather,
        ...?m.people,
        ...?m.hobbies,
        ...?m.work,
        ...?m.health,
        ...?m.chores,
        ...?m.relationship,
        ...?m.other,
      ];
      m.customBlocks?.values.forEach(allIds.addAll);
      for (var id in allIds) {
        iconCounts[id] = (iconCounts[id] ?? 0) + 1;
      }
    }

    final sorted = iconCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(10);
    final rawMap = RecordingBlockController.instance.allIconMetadataById;

    return top.map((e) {
      final rec = rawMap[e.key];
      final meta = rec != null
          ? IconMetadata(
              id: rec.id,
              label: rec.label,
              iconPath: rec.iconPath,
              category: IconCategory.expression)
          : IconMetadata(
              id: e.key,
              label: e.key,
              iconPath: '',
              category: IconCategory.expression);
      return MapEntry(meta, e.value);
    }).toList();
  }
}
