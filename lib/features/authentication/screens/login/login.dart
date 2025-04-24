import 'package:moodiary/common/styles/spacing_styles.dart';
import 'package:moodiary/common/widgets/login_signup/form_divider.dart';
import 'package:moodiary/common/widgets/login_signup/social_buttons.dart';
import 'package:moodiary/features/authentication/screens/login/widgets/login_form.dart';
import 'package:moodiary/features/authentication/screens/login/widgets/login_header.dart';
import 'package:moodiary/utils/constants/sizes.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  ///TODO Sign Up Screen

  ///TODO Forgot Password Screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///Logo, Title & Sub-Title
              const TLoginHeader(),

              ///Form
              const TLoginForm(),

              ///Divider
              TFormDivider(dividerText: "OR"),
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
