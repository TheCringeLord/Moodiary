import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

import '../../../../../utils/validators/validation.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            ///* Email
            TextFormField(
              validator: (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            ///* Password
            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText("Password", value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.direct_right),
                labelText: TTexts.password,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Iconsax.eye_slash),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            ///* Remember Me & Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Remember Me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                ///Forget Password
                TextButton(
                  onPressed: () {},
                  // onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(TTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            ///* Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(TTexts.signIn),
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            ///* Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                // onPressed: () => Get.to(() => const SignupScreen()),
                child: Text(
                  TTexts.createAccount,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
