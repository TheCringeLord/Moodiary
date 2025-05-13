import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TFrequentlyIcon extends StatelessWidget {
  final int rank;
  final String iconPath;
  final String label;
  final int count;
  final bool isPlaceholder;

  const TFrequentlyIcon({
    super.key,
    required this.rank,
    required this.iconPath,
    required this.label,
    required this.count,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ///* Card
            TRoundedContainer(
              backgroundColor: dark ? TColors.dark : TColors.light,
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///* Icon
                  TRoundedContainer(
                    width: 60,
                    height: 60,
                    radius: 60 / 2,
                    backgroundColor: dark ? TColors.lightGrey : TColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.iconXs),
                      child: isPlaceholder
                          ? Icon(Iconsax.gallery,
                              size: 30,
                              color: dark ? TColors.darkGrey : TColors.grey)
                          : Image.asset(
                              iconPath,
                              width: 60,
                              height: 60,
                            ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  ///* Label
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  ///* Count
                  Text(
                    "x$count",
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            ///* Rank Badge
            Positioned(
              top: 9,
              left: 14,
              child: Text(
                "$rank",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
