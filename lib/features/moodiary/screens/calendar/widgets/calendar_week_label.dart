import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

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
