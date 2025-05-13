import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/calendar_controller.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
