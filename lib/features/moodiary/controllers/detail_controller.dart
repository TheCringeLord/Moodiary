import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/models/mood_model.dart';
import 'package:moodiary/features/moodiary/models/icon_metadata.dart';
import 'package:moodiary/data/repositories/mood/mood_repository.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';
import 'package:moodiary/utils/constants/enums.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../models/recording_icon_mode.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();

  /// Currently selected month
  final Rx<DateTime> selectedMonth = Rx(
    DateTime(DateTime.now().year, DateTime.now().month),
  );
  final allIconMetadataById = <String, RecordingIconModel>{}.obs;

  /// All fetched moods for the month
  final RxList<MoodModel> detailedMoods = <MoodModel>[].obs;

  /// Resolved icons per mood‐date
  final RxMap<DateTime, List<IconMetadata>> iconsByDate =
      <DateTime, List<IconMetadata>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // now this initial value matches one of availableMonths
    ever(selectedMonth, (_) => loadDetailsForMonth(selectedMonth.value));
    loadDetailsForMonth(selectedMonth.value);
  }

  /// Dropdown choices: months from 2023 up to now
  List<DateTime> get availableMonths {
    final now = DateTime.now();
    final months = <DateTime>[];
    for (var year = now.year; year >= 2023; year--) {
      for (var m = 12; m >= 1; m--) {
        final dt = DateTime(year, m);
        if (dt.isAfter(now)) continue;
        months.add(dt);
      }
    }
    return months;
  }

  Future<void> loadDetailsForMonth(DateTime month) async {
  // 🔐 Ensure icon metadata is loaded
  final recCtrl = RecordingBlockController.instance;
  if (recCtrl.allIconMetadataById.isEmpty) {
    await recCtrl.fetchBlocks(); 
  }

  final moodList = await MoodRepository.instance.getMoodsByMonth(month).first;
  detailedMoods.assignAll(moodList);

  final rawIconMap = recCtrl.allIconMetadataById;
  final Map<DateTime, List<IconMetadata>> result = {};

  for (final mood in moodList) {
    final allIds = <String>[
      ...?mood.emotions,
      ...?mood.weather,
      ...?mood.people,
      ...?mood.hobbies,
      ...?mood.work,
      ...?mood.health,
      ...?mood.chores,
      ...?mood.relationship,
      ...?mood.other,
    ];
    mood.customBlocks?.values.forEach(allIds.addAll);

    result[mood.date] = allIds.map((id) {
      final meta = rawIconMap[id];
      return meta != null
          ? IconMetadata(
              id: meta.id,
              label: meta.label,
              iconPath: meta.iconPath,
              category: IconCategory.expression,
            )
          : IconMetadata(
              id: id,
              label: id,
              iconPath: '',
              category: IconCategory.expression,
            );
    }).toList();
  }

  iconsByDate.assignAll(result);
}


  Future<void> showMonthPickerDialog(BuildContext context) async {
    final current = selectedMonth.value;
    final dark = THelperFunctions.isDarkMode(context);
    final months = List.generate(12, (i) => i + 1);
    final years = List.generate(101, (i) => 2000 + i);
    int selectedMonthInt = current.month;
    int selectedYear = current.year;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          ),
          backgroundColor: dark ? TColors.dark : TColors.white,
          child: SizedBox(
            height: 400,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  Text("Choose Month",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            squeeze: 1.1,
                            scrollController: FixedExtentScrollController(
                                initialItem: selectedMonthInt - 1),
                            itemExtent: 36,
                            onSelectedItemChanged: (index) {
                              selectedMonthInt = months[index];
                            },
                            children: months
                                .map((m) => Center(
                                      child: Text(
                                        THelperFunctions.getMonthName(m),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            squeeze: 1.1,
                            scrollController: FixedExtentScrollController(
                                initialItem: years.indexOf(current.year)),
                            itemExtent: 36,
                            onSelectedItemChanged: (index) {
                              selectedYear = years[index];
                            },
                            children: years
                                .map((y) => Center(
                                      child: Text(
                                        '$y',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.lightGrey,
                            foregroundColor: TColors.darkerGrey,
                            side: const BorderSide(color: TColors.grey),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            selectedMonth.value =
                                DateTime(selectedYear, selectedMonthInt);
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
