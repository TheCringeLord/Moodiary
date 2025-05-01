import 'package:moodiary/data/repositories/authentication/authentication_repository.dart';
import 'package:moodiary/features/personalization/controllers/user_controller.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/helpers/network_manager.dart';
import 'package:moodiary/utils/popups/full_screen_loader.dart';
import 'package:moodiary/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../utils/exceptions/platform_exceptions.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  ///* Variable
  final localStorage = GetStorage(); //local storage for user data
  final email = TextEditingController(); //controller for email input
  final password = TextEditingController(); //controller for password input
  final rememberMe = false.obs; //to check if user wants to be remembered
  final hidePassword = true.obs; //to check if user wants to hide password
  GlobalKey<FormState> loginFormKey =
      GlobalKey<FormState>(); //key for form validation
  final userController = Get.put(UserController()); //user controller

  @override
  void onInit() {
    email.text = localStorage.read("REMEMBER_ME_EMAIL") ??
        ""; //get email from local storage
    password.text = localStorage.read("REMEMBER_ME_PASSWORD") ?? "";
    super.onInit();
  }

  ///* -- Email and Password Sign In
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          "Logging you in...", TImages.docerAnimation);
      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }
      // Validate Form
      if (!loginFormKey.currentState!.validate()) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //Save User Data in Local Storage if remember me is checked
      if (rememberMe.value) {
        localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      }

      //Log in user with email and password authentication
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Redirect to the home screen if login is successful
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: "Oh no!",
        message: e.toString(),
      );
    }
  }

  ///* -- Google Sign In
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          "Logging you in...", TImages.docerAnimation);
      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: "Offline", message: "Please check your internet.");
        return;
      }

      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Force sign out before sign in to show account chooser
      await googleSignIn.signOut();

      //Log in user with Google Sign In authentication
      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      //Save user Record
      await userController.saveUserRecord(userCredentials);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Redirect to the home screen if login is successful
      AuthenticationRepository.instance.screenRedirect();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: "Oh no!",
        message: e.toString(),
      );
    }
  }
}
