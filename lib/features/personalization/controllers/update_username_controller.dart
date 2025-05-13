import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/data/repositories/user/user_repository.dart';
import 'package:moodiary/features/personalization/controllers/user_controller.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/helpers/network_manager.dart';
import 'package:moodiary/utils/popups/full_screen_loader.dart';
import 'package:moodiary/utils/popups/loaders.dart';


class UpdateUsernameController extends GetxController {
  static UpdateUsernameController get instance => Get.find();

  // Variables
  final username = TextEditingController();
  final updateUsernameFormKey = GlobalKey<FormState>();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());

  // Initialize with current username
  @override
  void onInit() {
    super.onInit();
    username.text = userController.user.value.username;
  }

  // Cleanup
  @override
  void onClose() {
    username.dispose();
    super.onClose();
  }

  /// Update username in Firebase and locally
  Future<void> updateUsername() async {
    try {
      // 1. Start loading
      TFullScreenLoader.openLoadingDialog(
        "Updating your username",
        TImages.docerAnimation,
      );

      // 2. Check network connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return TLoaders.errorSnackBar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again",
        );
      }

      // 3. Form validation
      if (!updateUsernameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // 4. Check if username is unique
      final newUsername = username.text.trim();
      if (newUsername == userController.user.value.username) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: "No Changes",
          message: "This is already your current username",
        );
        return Get.back();
      }

      // 6. Update username in Firebase
      final usernameData = {'username': newUsername};
      await userRepository.updateSingleField(usernameData);

      // 7. Update locally
      userController.user.update((user) {
        if (user != null) {
          user.username = newUsername;
        }
      });

      // 8. Remove loader
      TFullScreenLoader.stopLoading();

      // 9. Show success message
      TLoaders.successSnackBar(
        title: "Username Updated",
        message: "Your username has been changed successfully",
      );

      // 10. Return to profile
      Get.back(result: true);
    } catch (e) {
      // Handle any errors
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: e.toString(),
      );
    }
  }
}
