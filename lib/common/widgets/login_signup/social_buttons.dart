import 'package:get/get.dart';
import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../features/authentication/controllers/login/login_controller.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => controller.googleSignIn(),
        icon: const Image(
          width: TSizes.iconLg,
          height: TSizes.iconLg,
          image: AssetImage(TImages.google),
        ),
        label: Text(
          "Continue with Google",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
