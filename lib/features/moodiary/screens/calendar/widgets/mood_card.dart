import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';

import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';

import '../../../../../utils/helpers/helper_functions.dart';
import '../../../models/mood_model.dart';

class TMoodCard extends StatelessWidget {
  const TMoodCard({
    super.key,
    required this.date,
    required this.mood,
    this.onEdit,
    this.onDelete,
  });

  final DateTime date;
  final String mood;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    const double size = 56;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Iconsax.edit),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Iconsax.trash),
            ),
          ],
        ),
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          backgroundColor: TColors.white,
          width: double.infinity,
          child: Row(
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      TRoundedContainer(
                        width: size,
                        height: size,
                        radius: size / 2,
                        showBorder: false,
                        backgroundColor: Mood.getBackgroundColor(mood, false),
                      ),
                      Image.asset(
                        Mood.getMoodImage(mood),
                        fit: BoxFit.cover,
                        width: size * 0.8,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TRoundedContainer(
                    width: 70,
                    height: 70,
                    backgroundColor: TColors.softGrey,
                    child: Center(
                      child: Text(
                        THelperFunctions.getFormattedDateDayDate(date),
                        style: Theme.of(context).textTheme.bodyLarge?.apply(
                              color: TColors.darkGrey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
