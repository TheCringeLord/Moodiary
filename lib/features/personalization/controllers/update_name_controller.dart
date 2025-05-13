import 'package:moodiary/data/repositories/user/user_repository.dart';
import 'package:moodiary/features/personalization/controllers/user_controller.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/popups/full_screen_loader.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/loaders.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  ///* Variables
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  ///* Fetch user records
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      // 1. Show loader
      TFullScreenLoader.openLoadingDialog(
        "We are updating your information",
        TImages.docerAnimation,
      );

      // 2. Check network
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: "No Internet Connection",
            message: "Please check your internet connection");
        return;
      }

      // 3. Validate form
      if (!updateUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // 4. Write to Firebase
      Map<String, dynamic> name = {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
      };
      await userRepository.updateSingleField(name);

      // 5. Update your Rx<User>
      userController.user.update((value) {
        if (value != null) {
          value.firstName = firstName.text.trim();
          value.lastName = lastName.text.trim();
        }
      });

      // 6. Close loader
      TFullScreenLoader.stopLoading();

      // 7. Show success snackbar
      TLoaders.successSnackBar(
        title: "Congratulations",
        message: "Your name has been updated successfully",
      );

      // 8. Pop ChangeName and return `true` (ONLY ONE Get.back())
      Get.back(result: true);
    } catch (e) {
      // 9. Make sure loader is closed on error
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: "Oh no!",
        message: e.toString(),
      );
    }
  }
}
