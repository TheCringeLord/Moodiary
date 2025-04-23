import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingDotNavigator extends StatelessWidget {
  const OnBoardingDotNavigator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = OnboardingController.instance;

    return Positioned(
      top: TDeviceUtils.getStatusBarHeight() + TSizes.defaultSpace,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? TColors.primary : TColors.dark,
          dotHeight: 6,
        ),
      ),
    );
  }
}
