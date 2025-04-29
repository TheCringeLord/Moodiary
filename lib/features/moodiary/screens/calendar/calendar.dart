import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/utils/constants/colors.dart';

import 'package:moodiary/utils/constants/sizes.dart';

import '../../../../common/widgets/custom_shape/container/rounded_container.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/calendar_controller.dart';
import '../moodlog/moodlog.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());

    return Scaffold(
      backgroundColor: TColors.light,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                ///* Header
                TCalendarHeader(),

                const SizedBox(height: TSizes.defaultSpace),

                ///* Week Labels
                TCalendarWeekLabel(),

                const SizedBox(height: TSizes.md),

                ///* Calendar Grid
                TCalendarGridView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TCalendarGridView extends StatelessWidget {
  const TCalendarGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CalendarController.instance;

    return Obx(() {
      final daysInMonth = controller.daysInMonth;
      final startWeekday = controller.startWeekday;

      return GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Important inside Column
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 0.7,
        ),
        itemCount: 42,
        itemBuilder: (context, index) {
          if (index < startWeekday || index >= startWeekday + daysInMonth) {
            return const SizedBox();
          }
          final dayNumber = index - startWeekday + 1;

          return GestureDetector(
            onTap: () {
              // TODO: Add navigation to MoodLogScreen later here
              controller.startMoodLogging(dayNumber);
            },
            child: Obx(
              () => TDateTile(
                dayNumber: dayNumber,
                isSelected: controller.selectedDay.value == dayNumber,
              ),
            ),
          );
        },
      );
    });
  }
}

class TDateTile extends StatelessWidget {
  const TDateTile({
    super.key,
    this.size = 50,
    required this.dayNumber,
    required this.isSelected,
  });

  final double size;
  final int dayNumber;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final calendarController = CalendarController.instance;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///* Circle with mood icon (if any)

        //TODO: Add mood icon using Stack
        TRoundedContainer(
          width: size,
          height: size,
          radius: size / 2,
          showBorder: calendarController.isToday(dayNumber),
          borderColor: TColors.primary,
          backgroundColor: TColors.white,
        ),

        const SizedBox(height: TSizes.xs),

        ///* Day number
        TRoundedContainer(
          padding: EdgeInsets.zero,
          backgroundColor: isSelected ? TColors.primary : Colors.transparent,
          child: SizedBox(
            width: size,
            child: Center(
              child: Text(
                dayNumber.toString(),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: isSelected ? TColors.white : TColors.textSecondary,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TCalendarWeekLabel extends StatelessWidget {
  const TCalendarWeekLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
      child: Row(
        children: THelperFunctions.getWeekdayLabels().map((label) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

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
            //TODO: Show month and year selector here
            onTap: () {},
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
