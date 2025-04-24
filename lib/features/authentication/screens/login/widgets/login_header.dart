
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/constants/text_strings.dart';

import 'package:flutter/material.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: TSizes.spaceBtwSections),
        // Image(
        //   height: 150,
        //   image: AssetImage(
        //     dark ? TImages.lightAppLogo : TImages.darkAppLogo,
        //   ),
        // ),

        Text(
          TTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(
          TTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
