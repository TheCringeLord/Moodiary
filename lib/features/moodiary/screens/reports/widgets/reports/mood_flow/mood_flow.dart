import 'package:flutter/material.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';

import 'package:moodiary/features/moodiary/screens/reports/widgets/reports/mood_flow/mood_flow_chart.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TMoodFlow extends StatelessWidget {
  const TMoodFlow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      backgroundColor: dark ? TColors.textPrimary : TColors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          Row(
            children: [
              Text("Mood Flow", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const TMoodFlowChart(),
        ],
      ),
    );
  }
}
