import 'package:moodiary/common/styles/spacing_styles.dart';
import 'package:moodiary/common/widgets/login_signup/form_divider.dart';
import 'package:moodiary/common/widgets/login_signup/social_buttons.dart';
import 'package:moodiary/features/authentication/screens/login/widgets/login_form.dart';
import 'package:moodiary/features/authentication/screens/login/widgets/login_header.dart';
import 'package:moodiary/utils/constants/sizes.dart';

import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.white,
      body: const SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///* Logo, Title & Sub-Title
              TLoginHeader(),

              ///* Form
              TLoginForm(),

              ///* Divider
              TFormDivider(dividerText: "OR"),
              SizedBox(height: TSizes.spaceBtwSections),

              ///* Footer
              TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
