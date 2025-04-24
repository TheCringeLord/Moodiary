import 'package:flutter/material.dart';

import 'package:moodiary/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/device/device_utility.dart';

import 'package:iconsax/iconsax.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnboardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: TColors.primary,
          padding: const EdgeInsets.all(TSizes.iconMd),
        ),
        child: const Icon(
          Iconsax.arrow_right_3,
          color: Colors.white,
          size: TSizes.defaultSpace,
        ),
      ),
    );
  }
}
