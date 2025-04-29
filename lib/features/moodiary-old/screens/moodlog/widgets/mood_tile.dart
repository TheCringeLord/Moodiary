import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import '../../../controllers/mood_log_controller.dart';

class TMoodTile extends StatelessWidget {
  const TMoodTile({
    super.key,
    required this.image,
    required this.index,
    this.size = 50,
  });

  final String image;
  final int index;
  final double size;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoodlogController>();

    return Obx(() {
      final isSelected = controller.selectedMoodIndex.value == index;

      return GestureDetector(
        onTap: () => controller.selectMood(index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            TRoundedContainer(
              width: size,
              height: size,
              radius: size / 2,
              showBorder: true,
              backgroundColor: Colors.transparent,
            ),
            ClipOval(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.transparent : Colors.grey,
                  BlendMode.saturation,
                ),
                child: Image.asset(
                  image,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
