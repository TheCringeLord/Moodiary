import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/features/moodiary/screens/history/widgets/detail_card.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../controllers/detail_controller.dart';
import '../../controllers/recording_block_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ensure controller is registered
    Get.put(RecordingBlockController());
    final controller = Get.put(DetailController());

    return Scaffold(
      appBar: TAppBar(
        title:
            Text("History", style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            // Month picker
            Obx(() {
              final currentMonth = controller.selectedMonth.value;
              return InkWell(
                onTap: () => controller.showMonthPickerDialog(context),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.sm,
                    vertical: TSizes.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${THelperFunctions.getMonthName(currentMonth.month)} ${currentMonth.year}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: TSizes.xs),
                      const Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: TSizes.spaceBtwSections),

            // detail cards
            Expanded(
              child: Obx(() {
                final list = controller.detailedMoods;
                if (list.isEmpty) {
                  return const Center(child: Text("No records for this month"));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (_, i) {
                    final mood = list[i];
                    final icons = controller.iconsByDate[mood.date] ?? [];
                    return TDetailCard(mood: mood, icons: icons);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
