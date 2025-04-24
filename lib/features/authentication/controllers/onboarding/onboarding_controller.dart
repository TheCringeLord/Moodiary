import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/login/login.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  ///Variable
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  ///Update Current Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  ///Jump to the specific dot selected page.
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  ///Update Current Index & Jump to next Page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      // final storage = GetStorage();
      // storage.write('isFirstTime', false);
      Get.to(() => const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  ///Update Current Index & Jump to last Page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
