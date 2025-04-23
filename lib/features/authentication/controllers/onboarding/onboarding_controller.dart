import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  ///Variable
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  final buttonText = 'Next'.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to page changes and keep currentPageIndex & buttonText in sync:
    pageController.addListener(() {
      final page = pageController.page?.round() ?? 0;
      if (page != currentPageIndex.value) {
        currentPageIndex.value = page;
        _updateButtonText();
      }
    });
  }

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
      final storage = GetStorage();
      storage.write('isFirstTime', false);
      // Get.to(() => const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void _updateButtonText() {
    // 2) Change the RxString’s value
    buttonText.value = (currentPageIndex.value == 2) ? 'Get Started' : 'Next';
  }

  ///Update Current Index & Jump to last Page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
