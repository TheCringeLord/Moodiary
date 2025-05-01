import 'package:moodiary/data/repositories/authentication/authentication_repository.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/helpers/network_manager.dart';
import 'package:moodiary/utils/popups/full_screen_loader.dart';
import 'package:moodiary/utils/popups/loaders.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/password_configuration/reset_password.dart';



class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  ///* Variable
  final email = TextEditingController(); //controller for email input
  GlobalKey<FormState> forgetPasswordFormKey =
      GlobalKey<FormState>(); //key for form validation

  ///* Send Password Reset Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          "Sending password reset email...", TImages.docerAnimation);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate Form
      if (!forgetPasswordFormKey.currentState!.validate()) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send Password Reset Email
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //remove loader
      TFullScreenLoader.stopLoading();

      //Show Success Message
      TLoaders.successSnackBar(
          title: "Email Sent",
          message: "Check your email for password reset link.".tr);

      //redirect
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      //remove loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh no!", message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          "Sending password reset email...", TImages.docerAnimation);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send Password Reset Email
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //remove loader
      TFullScreenLoader.stopLoading();

      //Show Success Message
      TLoaders.successSnackBar(
          title: "Email Sent",
          message: "Check your email for password reset link.".tr);
    } catch (e) {
      //remove loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh no!", message: e.toString());
    }
  }
}
