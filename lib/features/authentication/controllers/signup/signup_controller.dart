import 'package:moodiary/data/repositories/authentication/authentication_repository.dart';
import 'package:moodiary/data/repositories/user/user_repository.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/helpers/network_manager.dart';
import 'package:moodiary/utils/popups/full_screen_loader.dart';
import 'package:moodiary/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../personalization/models/user_model.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///* Variable
  final hidePassword = true.obs; //to hide/show password
  final privacyPolicy = false.obs; //to check if user accepted privacy policy
  final email = TextEditingController(); //controller for email input
  final password = TextEditingController(); //controller for password input
  final firstName = TextEditingController(); //controller for first name input
  final lastName = TextEditingController(); //controller for last name input
  final username = TextEditingController(); //controller for username input
  final phoneNumber =
      TextEditingController(); //controller for phone number input
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); //key for form validation
  ///* -- SignUp
  void signUp() async {
    try {
      // Privacy Policy Check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
            title: "Accept Terms & Conditions",
            message:
                "Please accept the terms and conditions to create your account.");
        return;
      }
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          "We are processing your information...", TImages.docerAnimation);
      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }
      // Validate Form
      if (!signupFormKey.currentState!.validate()) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Register User in the Firebase Auth
      final userCredential =
          await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      // Save Auth user in the Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      //remove loader
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(
          title: "Congratulations!",
          message:
              "Your account has been created successfully! Please verify your email address to continue.");

      // Move to Verification Screen
      Get.to(
        () => VerifyEmailScreen(
          email: email.text.trim(),
        ),
      );
    } catch (e) {
      //remove loader
      TFullScreenLoader.stopLoading();
      //Show some generic error message
      TLoaders.errorSnackBar(title: "Oh no!", message: e.toString());
    }
  }
}
