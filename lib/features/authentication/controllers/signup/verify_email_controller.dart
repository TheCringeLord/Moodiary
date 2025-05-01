import 'dart:async';


import 'package:moodiary/data/repositories/authentication/authentication_repository.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/constants/text_strings.dart';
import 'package:moodiary/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();
  Timer? _autoRedirectTimer;

  ///* Send Email Whenever Verify Screen appears & Set Timer for auto redirect
  @override
  void onInit() {
    super.onInit();
    sendEmailVerification();
    _startAutoRedirectTimer();
  }

  @override
  void onClose() {
    _autoRedirectTimer?.cancel();
    super.onClose();
  }

  ///* Send Email Verification Link
  sendEmailVerification() async {
    try {
      await (AuthenticationRepository.instance.sendEmailVerification());
      TLoaders.successSnackBar(
          title: "Email Sent",
          message:
              "We have sent you an email verification link. Please check your inbox and verify your email address.");
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh no!", message: e.toString());
    }
  }

  ///* Timer to automatically redirect on Email Verification
  void _startAutoRedirectTimer() {
    _autoRedirectTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified ?? false) {
          timer.cancel();
          Get.offAll(
            () => SuccessScreen(
              image: TImages.successfullyRegisterAnimation,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () =>
                  AuthenticationRepository.instance.screenRedirect(),
            ),
          );
        }
      },
    );
  }

  ///* Manually Check if Email is Verified
  checkEmailVerification() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.offAll(
        () => SuccessScreen(
          image: TImages.successfullyRegisterAnimation,
          title: TTexts.yourAccountCreatedTitle,
          subTitle: TTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}
