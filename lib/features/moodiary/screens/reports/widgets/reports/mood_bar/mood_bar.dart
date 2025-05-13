import 'package:flutter/material.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';

import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/mood_bar/mood_bar_chart.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TMoodBar extends StatelessWidget {
  const TMoodBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      backgroundColor: dark ? TColors.textPrimary : TColors.white,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text("Mood Bar", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const TMoodBarChart(),
        ],
      ),
    );
  }
}
