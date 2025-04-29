import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary-old/screens/calendar/widgets/date_tile.dart';
import 'package:moodiary/utils/constants/colors.dart';

import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../controllers/activity_customization_controller.dart';
import '../../../controllers/calendar_controller.dart';

/// A fully custom calendar UI built using TDateTile.
class TCustomCalendar extends StatelessWidget {
  const TCustomCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());
    Get.put(ActivityCustomizationController());

    return Obx(
      () {
        final currentMonth = controller.currentMonth.value;
        final daysInMonth =
            DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
        final firstDayOfMonth =
            DateTime(currentMonth.year, currentMonth.month, 1);

        final startWeekday = firstDayOfMonth.weekday % 7;

        return Column(
          children: [
            _buildHeader(controller, currentMonth),
            const SizedBox(height: TSizes.defaultSpace),
            _buildWeekLabels(),
            const SizedBox(height: TSizes.md),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero, // Remove grid padding
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 0.7,
                ),

                itemCount: 42,
                itemBuilder: (context, index) {
                  if (index < startWeekday ||
                      index >= startWeekday + daysInMonth) {
                    return const SizedBox();
                  }

                  final day = index - startWeekday + 1;
                  final date =
                      DateTime(currentMonth.year, currentMonth.month, day);

                  return GestureDetector(
                    onTap: () => controller.selectDate(date),
                    child: Obx(
                      () {
                        final isToday = controller.isToday(date);
                        final isSelected = controller.isSelected(date);
                        return TDateTile(
                          day: day,
                          isToday: isToday,
                          isSelected: isSelected,
                          mood: controller.getMoodForDate(date),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(CalendarController controller, DateTime currentMonth) {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous month button
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.goToPreviousMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            // Month and year selector
            InkWell(
              onTap: () => _showMonthPickerDialog(context, controller),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${THelperFunctions.getMonthName(currentMonth.month)} ${currentMonth.year}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge, // Remove .apply() and use theme directly
                    ),
                    const SizedBox(width: TSizes.xs),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),

            // Next month button
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: controller.goToNextMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWeekLabels() {
    final labels = THelperFunctions.getWeekdayLabels();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
      child: Row(
        children: labels.map((label) {
          return Expanded(
            // Equal width for all labels
            child: Center(
              // Center-align text
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12, // Match date text size
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showMonthPickerDialog(
      BuildContext context, CalendarController controller) async {
    final current = controller.currentMonth.value;

    final dark = THelperFunctions.isDarkMode(context);

    // Month and year options
    final months = List.generate(12, (i) => i + 1);
    final years = List.generate(101, (i) => 2000 + i);

    // Temp state
    int selectedMonth = current.month;
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
                  Text(
                    "Where to?",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Pickers
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Month Picker
                        Expanded(
                          child: CupertinoPicker(
                            squeeze: 1.1,
                            scrollController: FixedExtentScrollController(
                                initialItem: selectedMonth - 1),
                            itemExtent: 36,
                            onSelectedItemChanged: (index) {
                              selectedMonth = months[index];
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
                        // Year Picker
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

                  // Buttons
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
                            controller.currentMonth.value =
                                DateTime(selectedYear, selectedMonth);
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
