import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/features/personalization/controllers/update_username_controller.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/constants/text_strings.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';
import 'package:moodiary/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeUserName extends StatelessWidget {
  const ChangeUserName({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(UpdateUsernameController());
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.white,
      // Appbar
      appBar: TAppBar(
        title: Text("Change Username",
            style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Headings
            Text(
              "Use real name for easy verification. This name will be appeared on several places in the app.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Text field and button
            Form(
              key: controller.updateUsernameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.username,
                    validator: (value) =>
                        TValidator.validateEmptyText("Username", value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: TTexts.username,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateUsername(),
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
