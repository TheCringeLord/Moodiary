import 'package:flutter/services.dart';

import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/data/repositories/authentication/authentication_repository.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/predefined_icon_picker.dart';

import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/utils/popups/loaders.dart';

import '../../../common/widgets/images/circular_image.dart';
import '../../../common/widgets/text/section_heading.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../moodiary/models/icon_metadata.dart';

import '../controllers/user_controller.dart';
import 'change_name.dart';
import 'change_username.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      backgroundColor:
          THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.white,
      appBar: TAppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),

      ///*------Body------*///
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            ///Profile Image
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(
                    () => TCircularImage(
                      image: controller.user.value.profilePicture.isEmpty
                          ? TImages.neutralExpression
                          : controller.user.value.profilePicture,
                      backgroundColor: THelperFunctions.isDarkMode(context)
                          ? TColors.textPrimary
                          : TColors.light,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final dark = THelperFunctions.isDarkMode(context);
                      showModalBottomSheet<IconMetadata>(
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const TPredefinedIconPicker(),
                      ).then((selectedIcon) {
                        if (selectedIcon != null) {
                          // Update profile picture with the selected icon
                          _updateProfilePicture(selectedIcon.iconPath);
                        }
                      });
                    },
                    child: const Text("Change Profile Picture"),
                  ),
                ],
              ),
            ),

            ///Details
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///Heading Profile info
            const TSectionHeading(
              title: "Profile Information",
              showActionButton: false,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            Obx(
              () => TProfileMenu(
                title: "Name",
                value: controller.user.value.fullName,
                onPressed: () async {
                  final didUpdate = await Get.to(() => const ChangeName());
                  if (didUpdate == true) {
                    await controller.fetchUserRecord();
                  }
                },
              ),
            ),

            Obx(
              () => TProfileMenu(
                title: "Username",
                value: controller.user.value.username,
                onPressed: () async {
                  final didUpdate = await Get.to(() => const ChangeUserName());
                  if (didUpdate == true) {
                    await controller.fetchUserRecord();
                  }
                },
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///Heading Personal info
            const TSectionHeading(
              title: "Personal Information",
              showActionButton: false,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
              title: "User ID",
              value: controller.user.value.id,
              icon: Iconsax.copy,
              onPressed: () =>
                  _copyToClipboard(controller.user.value.id, 'User ID'),
            ),
            TProfileMenu(
              title: "E-mail",
              value: controller.user.value.email,
              icon: Iconsax.copy,
              onPressed: () => _copyToClipboard(
                  controller.user.value.email, 'Email address'),
            ),
            TProfileMenu(
              title: "Phone Number",
              value: controller.user.value.phoneNumber,
              icon: Iconsax.copy,
              onPressed: () => _copyToClipboard(
                  controller.user.value.phoneNumber, 'Phone number'),
            ),

            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            Center(
              child: TextButton(
                onPressed: () => AuthenticationRepository.instance.logout(),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: TColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add this method to your ProfileScreen class
  void _copyToClipboard(String? text, String label) {
    if (text == null || text.isEmpty) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: "No $label available to copy.",
      );
      return;
    }

    Clipboard.setData(ClipboardData(text: text));
    TLoaders.successSnackBar(
      title: "Copied to Clipboard",
      message: "$label copied successfully.",
    );
  }

  Future<void> _updateProfilePicture(String imagePath) async {
    final controller = UserController.instance;

    try {
      // Show loading indicator
      TFullScreenLoader.openLoadingDialog(
        "Updating profile picture",
        TImages.docerAnimation,
      );

      // Check network connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return TLoaders.errorSnackBar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again",
        );
      }

      // Update profile picture in Firebase
      final pictureData = {'profilePicture': imagePath};
      await controller.userRepository.updateSingleField(pictureData);

      // Update locally
      controller.user.update((user) {
        if (user != null) {
          user.profilePicture = imagePath;
        }
      });

      // Remove loader
      TFullScreenLoader.stopLoading();

      // Show success message
      TLoaders.successSnackBar(
        title: "Profile Picture Updated",
        message: "Your profile picture has been changed successfully",
      );
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
