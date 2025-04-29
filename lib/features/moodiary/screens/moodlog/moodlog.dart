import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shape/container/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class MoodlogScreen extends StatelessWidget {
  const MoodlogScreen({super.key, required this.selectedDate});
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          THelperFunctions.getFormattedDateDayMonthYear(
            selectedDate,
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.setting_2),
          ),
        ],
        showBackArrow: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///* Main Mood Selection
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.textPrimary
                    : TColors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "How was your day?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    ///* Main Mood Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //* Main Mood
                        TMoodIcon(),
                        TMoodIcon(),
                        TMoodIcon(),
                        TMoodIcon(),
                        TMoodIcon(),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              ///TODO: Other Activities Block to be added here
            ],
          ),
        ),
      ),
    );
  }
}

class TMoodIcon extends StatelessWidget {
  const TMoodIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          TRoundedContainer(
            width: 50,
            height: 50,
            radius: 50 / 2,
            showBorder: true,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
