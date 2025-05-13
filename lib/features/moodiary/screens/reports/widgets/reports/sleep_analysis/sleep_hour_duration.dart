import 'package:flutter/material.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';

class TSleepHourDuration extends StatelessWidget {
  const TSleepHourDuration({
    super.key,
    required this.text,
    required this.color,
    required this.totalDay,
    required this.dayInMonth,
  });

  final String text;
  final Color color;
  final String totalDay;
  final String dayInMonth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              height: 20,
              width: 20,
              radius: TSizes.cardRadiusXs,
              backgroundColor: color,
            ),
            const SizedBox(width: TSizes.sm),
            Text(text, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
            child: Divider(
              color: TColors.grey.withAlpha(100),
              height: TSizes.sm,
              thickness: 1,
            ),
          ),
        ),
        Row(
          children: [
            Text(totalDay, style: Theme.of(context).textTheme.labelSmall),
            Text(
              " / $dayInMonth",
              style: Theme.of(context).textTheme.labelSmall!.apply(
                    color: TColors.darkGrey,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
