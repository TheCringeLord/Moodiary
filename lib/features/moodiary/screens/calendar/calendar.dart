import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/features/moodiary/screens/calendar/widgets/calendar_grid_view.dart';
import 'package:moodiary/features/moodiary/screens/calendar/widgets/calendar_header.dart';
import 'package:moodiary/features/moodiary/screens/calendar/widgets/calendar_week_label.dart';
import 'package:moodiary/features/moodiary/screens/history/widgets/detail_card.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/customize_recording_block.dart';
import 'package:moodiary/utils/constants/colors.dart';

import 'package:moodiary/utils/constants/sizes.dart';

import '../../../../common/widgets/images/circular_image.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/calendar_controller.dart';
import '../../controllers/mood_controller.dart';
import '../../controllers/recording_block_controller.dart';
import '../../models/icon_metadata.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MoodController());
    Get.put(RecordingBlockController());
    final calCtrl = Get.put(CalendarController());
    final dark = THelperFunctions.isDarkMode(context);
    Get.put(UserController());

    final userController = Get.put(UserController());

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      appBar: TAppBar(
        title: Row(
          children: [
            Obx(
              () => TCircularImage(
                image: userController.user.value.profilePicture.isEmpty
                    ? TImages.neutralExpression
                    : userController.user.value.profilePicture,
                isNetworkImage: THelperFunctions.isNetworkImage(
                    userController.user.value.profilePicture),
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.textPrimary
                    : TColors.white,
                width: 55,
                height: 55,
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TSizes.xs),
                  Text(
                    userController.user.value.username,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    "${userController.user.value.firstName} ${userController.user.value.lastName}",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        showBackArrow: false,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () {
              Get.to(() => const CustomizeRecordingBlockScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///* Header
              const TCalendarHeader(),

              const SizedBox(height: TSizes.defaultSpace),

              ///* Week Labels
              const TCalendarWeekLabel(),

              const SizedBox(height: TSizes.md),

              ///* Calendar Grid
              const SizedBox(
                height: 500,
                child: TCalendarGridView(),
              ),

              ///* Mood Cards To Show info

              Obx(() {
                Get.put(RecordingBlockController());
                if (!calCtrl.showMoodCard.value ||
                    calCtrl.selectedDate.value == null) {
                  return const SizedBox.shrink();
                }
                final date = calCtrl.selectedDate.value!;
                // find the mood for that day
                final mood = calCtrl.monthlyMoods.firstWhereOrNull((m) =>
                    m.date.year == date.year &&
                    m.date.month == date.month &&
                    m.date.day == date.day);
                if (mood == null) {
                  return const SizedBox.shrink();
                }
                // resolve icons for this mood
                final rawMap =
                    RecordingBlockController.instance.allIconMetadataById;
                final allIds = <String>[
                  ...?mood.emotions,
                  ...?mood.weather,
                  ...?mood.people,
                  ...?mood.hobbies,
                  ...?mood.work,
                  ...?mood.health,
                  ...?mood.chores,
                  ...?mood.relationship,
                  ...?mood.other,
                ];
                mood.customBlocks?.values.forEach(allIds.addAll);
                final icons = allIds
                    .map((id) {
                      final rec = rawMap[id];
                      return rec != null
                          ? IconMetadata(
                              id: rec.id,
                              label: rec.label,
                              iconPath: rec.iconPath,
                              category: IconCategory.expression,
                            )
                          : IconMetadata(
                              id: id,
                              label: id,
                              iconPath: '',
                              category: IconCategory.expression,
                            );
                    })
                    .where((ic) => ic.iconPath.isNotEmpty)
                    .toList();

                // reuse your detail card widget
                return TDetailCard(mood: mood, icons: icons);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
