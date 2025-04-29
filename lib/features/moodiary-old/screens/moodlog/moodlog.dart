import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary-old/screens/moodlog/customize_activity.dart';
import 'package:moodiary/features/moodiary-old/screens/moodlog/widgets/activity_block.dart';
import 'package:moodiary/features/moodiary-old/screens/moodlog/widgets/mood_tile.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';
import '../../controllers/activity_customization_controller.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../controllers/mood_log_controller.dart';
import '../../models/activity_model.dart'; // Add this import

class MoodlogScreen extends StatelessWidget {
  const MoodlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarController = Get.find<CalendarController>();
    final customizationController = Get.put(ActivityCustomizationController());
    // ignore: unused_local_variable
    final moodController = Get.put(MoodlogController());
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          THelperFunctions.getFormattedDateDayMonthYear(
            calendarController.selectedDate.value!,
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => CustomizeActivityScreen()),
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
              ///* How was your day?
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
                    //* Mood Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TMoodTile(image: TImages.veryHappy, index: 0),
                        TMoodTile(image: TImages.happy, index: 1),
                        TMoodTile(image: TImages.neutral, index: 2),
                        TMoodTile(image: TImages.unHappy, index: 3),
                        TMoodTile(image: TImages.sad, index: 4),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              ///* Other Icons Records
              Obx(() {
                final categories =
                    customizationController.getVisibleCategories();
                return categories.isEmpty
                    ? Center(
                        child: Text(
                          "No activities available",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : Column(
                        children: categories.map((category) {
                          return Column(
                            children: [
                              TActivityBlock(
                                title: category['title'],
                                icons: List<ActivityIcon>.from(
                                    category['icons'] as List),
                                isCustomizationMode: false,
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                            ],
                          );
                        }).toList(),
                      );
              })
            ],
          ),
        ),
      ),

      ///*----Done Button----*///
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {
            final calendarController = Get.find<CalendarController>();
            final moodController = Get.find<MoodlogController>();
            if (calendarController.selectedDate.value != null) {
              moodController.saveMood(calendarController.selectedDate.value!);
            }
          },
          child: const Text("Done"),
        ),
      ),
    );
  }
}
