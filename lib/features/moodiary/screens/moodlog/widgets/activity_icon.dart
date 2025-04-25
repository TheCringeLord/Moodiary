import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';

import '../../../controllers/mood_log_controller.dart';
import '../../../models/activity_model.dart';

class TActivityIcon extends StatelessWidget {
  const TActivityIcon({
    super.key,
    required this.icon,
    required this.categoryName,
    this.size = 50,
  });
  
  final ActivityIcon icon;
  final String categoryName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoodlogController>();
    
    return Obx(() {
      final isSelected = controller.isActivitySelected(categoryName, icon.index);
      
      return GestureDetector(
        onTap: () => controller.toggleActivity(categoryName, icon.index),
        child: Column(
          children: [
            TRoundedContainer(
              width: size,
              height: size,
              radius: size / 2,
              showBorder: true,
              borderColor: isSelected ? TColors.primary : TColors.grey,
              backgroundColor: isSelected ? TColors.primary.withOpacity(0.1) : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: icon.buildIcon(size: size * 0.6),
              ),
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              icon.name, 
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? TColors.primary : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      );
    });
  }
}
