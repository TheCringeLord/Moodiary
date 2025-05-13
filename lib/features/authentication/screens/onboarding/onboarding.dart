import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/authentication/screens/onboarding/widgets/on_boarding_dot_navigator.dart';
import 'package:moodiary/utils/constants/image_strings.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/onboarding/onboarding_controller.dart';
import 'widgets/on_boarding_next_button.dart';
import 'widgets/on_boarding_page.dart';
import 'widgets/on_boarding_skip.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.white,
      body: Stack(
        children: [
          ///* Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.onBoarding1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.onBoarding2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.onBoarding3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          ///* Skip Button
          const OnBoardingSkip(),

          ///* Dot Navigation
          const OnBoardingDotNavigator(),

          ///* Next Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
