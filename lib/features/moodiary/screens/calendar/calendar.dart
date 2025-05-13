
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/appbar/appbar.dart';


import 'package:moodiary/features/moodiary/screens/moodlog/customize_recording_block.dart';
import 'package:moodiary/utils/constants/colors.dart';

import 'package:moodiary/utils/constants/sizes.dart';
import '../../../../common/widgets/custom_shape/container/rounded_container.dart';
import '../../../../common/widgets/images/circular_image.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/calendar_controller.dart';
import '../../controllers/mood_controller.dart';
import '../../controllers/recording_block_controller.dart';
import '../../models/icon_metadata.dart';
import '../history/history.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MoodController());
    Get.put(RecordingBlockController());
    final calCtrl = Get.put(CalendarController());
    final dark = THelperFunctions.isDarkMode(context);
    Get.put(UserController());

    final userController = Get.put(UserController());

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      appBar: TAppBar(
        title: Row(
          children: [
            Obx(
              () => TCircularImage(
                image: userController.user.value.profilePicture.isEmpty
                    ? TImages.neutralExpression
                    : userController.user.value.profilePicture,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.textPrimary
                    : TColors.white,
                width: 55,
                height: 55,
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TSizes.xs),
                  Text(
                    userController.user.value.username,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    "${userController.user.value.firstName} ${userController.user.value.lastName}",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        showBackArrow: false,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () {
              Get.to(() => const CustomizeRecordingBlockScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///* Header
              const TCalendarHeader(),

              const SizedBox(height: TSizes.defaultSpace),

              ///* Week Labels
              const TCalendarWeekLabel(),

              const SizedBox(height: TSizes.md),

              ///* Calendar Grid
              const SizedBox(
                height: 500,
                child: TCalendarGridView(),
              ),

              ///* Mood Cards To Show info

              Obx(() {
                Get.put(RecordingBlockController());
                if (!calCtrl.showMoodCard.value ||
                    calCtrl.selectedDate.value == null) {
                  return const SizedBox.shrink();
                }
                final date = calCtrl.selectedDate.value!;
                // find the mood for that day
                final mood = calCtrl.monthlyMoods.firstWhereOrNull((m) =>
                    m.date.year == date.year &&
                    m.date.month == date.month &&
                    m.date.day == date.day);
                if (mood == null) {
                  return const SizedBox.shrink();
                }
                // resolve icons for this mood
                final rawMap =
                    RecordingBlockController.instance.allIconMetadataById;
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
                final icons = allIds
                    .map((id) {
                      final rec = rawMap[id];
                      return rec != null
                          ? IconMetadata(
                              id: rec.id,
                              label: rec.label,
                              iconPath: rec.iconPath,
                              category: IconCategory.expression,
                            )
                          : IconMetadata(
                              id: id,
                              label: id,
                              iconPath: '',
                              category: IconCategory.expression,
                            );
                    })
                    .where((ic) => ic.iconPath.isNotEmpty)
                    .toList();

                // reuse your detail card widget
                return TDetailCard(mood: mood, icons: icons);
              }),
            ],
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
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 0.7,
        ),
        itemCount: 42,
        itemBuilder: (_, index) {
          if (index < startWeekday || index >= startWeekday + daysInMonth) {
            return const SizedBox();
          }

          ///* Calculate the day number based on the index
          final dayNumber = index - startWeekday + 1;

          return GestureDetector(
            onTap: () => controller.onDateTileTap(dayNumber),
            child: Obx(
              () => TDateTile(
                dayNumber: dayNumber,
                isSelected: controller.isSelectedDay(dayNumber),
                moodIcon: controller.getMoodEmojiForDay(dayNumber),
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
    this.moodIcon,
  });

  final double size;
  final int dayNumber;
  final bool isSelected;
  final String? moodIcon;

  @override
  Widget build(BuildContext context) {
    final calendarController = CalendarController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///* Circle with mood icon (if any)

        Stack(
          alignment: Alignment.center,
          children: [
            TRoundedContainer(
              width: size,
              height: size,
              radius: size / 2,
              showBorder: calendarController.isToday(dayNumber),
              borderColor: TColors.primary,
              backgroundColor: dark ? TColors.textPrimary : TColors.white,
            ),
            if (moodIcon != null)
              Image.asset(
                moodIcon!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
          ],
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
                      color: calendarController.isToday(dayNumber)
                          ? isSelected
                              ? TColors.white
                              : TColors.primary
                          : isSelected
                              ? TColors.white
                              : dark
                                  ? TColors.grey
                                  : TColors.textSecondary,
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
