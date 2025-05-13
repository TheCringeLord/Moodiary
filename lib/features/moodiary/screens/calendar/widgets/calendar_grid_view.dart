import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/calendar_controller.dart';

import 'package:moodiary/features/moodiary/screens/calendar/widgets/date_tile.dart';

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
