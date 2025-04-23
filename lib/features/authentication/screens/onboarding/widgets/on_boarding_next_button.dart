import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      right: 0,
      left: 0,
      child: Center(
        child: SizedBox(
          width: THelperFunctions.screenWidth() * 0.8,
          child: ElevatedButton(
            onPressed: OnboardingController.instance.nextPage,
            child: Obx(() => Text(
                  OnboardingController.instance.buttonText.value,
                )),
          ),
        ),
      ),
    );
  }
}
