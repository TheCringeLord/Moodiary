import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/common/widgets/login_signup/form_divider.dart';
import 'package:moodiary/common/widgets/login_signup/social_buttons.dart';
import 'package:moodiary/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:moodiary/utils/constants/colors.dart';

import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/constants/text_strings.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
      appBar: TAppBar(
        title: Text(
          TTexts.signupTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              const TSignupForm(),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
