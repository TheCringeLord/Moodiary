import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/features/moodiary/controllers/calendar_controller.dart';

import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/colors.dart';

class TCalendarHeader extends StatelessWidget {
  const TCalendarHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CalendarController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///* Previous Month
          IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () => controller.goToPreviousMonth(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          ///* Month and year selector
          InkWell(
            onTap: () => _showMonthPickerDialog(context, controller),
            borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.xs,
              ),
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${THelperFunctions.getMonthName(controller.currentMonth.value.month)} ${controller.currentMonth.value.year}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: TSizes.xs),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),
          ),

          ///* Next Month
          IconButton(
            icon: const Icon(Iconsax.arrow_right_3),
            onPressed: () => controller.goToNextMonth(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

Future<void> _showMonthPickerDialog(
    BuildContext context, CalendarController controller) async {
  final current = controller.currentMonth.value;
  final dark = THelperFunctions.isDarkMode(context);

  final months = List.generate(12, (i) => i + 1);
  final years = List.generate(101, (i) => 2000 + i);

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
                Text("Choose Month",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: TSizes.spaceBtwSections),
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
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
