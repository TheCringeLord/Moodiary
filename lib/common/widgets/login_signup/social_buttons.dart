import 'package:moodiary/utils/constants/image_strings.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
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
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Container(
    //       decoration: BoxDecoration(
    //         border: Border.all(color: TColors.grey),
    //         borderRadius: BorderRadius.circular(100),
    //       ),
    //       child: IconButton(
    //         onPressed: () {},
    //         icon: const Image(
    //           width: TSizes.iconMd,
    //           height: TSizes.iconMd,
    //           image: AssetImage(
    //             TImages.google,
    //           ),
    //         ),
    //       ),
    //     ),
    //     const SizedBox(width: TSizes.spaceBtwItems),
    //     Container(
    //       decoration: BoxDecoration(
    //         border: Border.all(color: TColors.grey),
    //         borderRadius: BorderRadius.circular(100),
    //       ),
    //       child: IconButton(
    //         onPressed: () {},
    //         icon: const Image(
    //           width: TSizes.iconMd,
    //           height: TSizes.iconMd,
    //           image: AssetImage(
    //             TImages.facebook,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
