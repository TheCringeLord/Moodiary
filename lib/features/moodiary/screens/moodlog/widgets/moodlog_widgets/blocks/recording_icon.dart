import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/features/moodiary/controllers/mood_controller.dart';
import 'package:moodiary/features/moodiary/models/recording_icon_mode.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TRecordingIcon extends StatelessWidget {
  final RecordingIconModel icon;
  final String blockId;
  final double size;

  const TRecordingIcon({
    super.key,
    required this.icon,
    required this.blockId,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final moodController = MoodController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(
      () {
        final isSelected = moodController.isIconSelected(blockId, icon.id);
        return GestureDetector(
          onTap: () => moodController.toggleIcon(blockId, icon.id),
          child: Column(
            children: [
              // … inside TRecordingIcon.build(), replace the TRoundedContainer child with:

              TRoundedContainer(
                width: size,
                height: size,
                radius: size / 2,
                backgroundColor: isSelected
                    ? TColors.light
                    : dark
                        ? TColors.white
                        : TColors.grey,
                child: ClipOval(
                  child: ColorFiltered(
                    colorFilter: isSelected
                        ? const ColorFilter.mode(
                            Colors.transparent, BlendMode.saturation)
                        : dark
                            ? const ColorFilter.mode(
                                TColors.lightGrey, BlendMode.saturation)
                            : const ColorFilter.mode(
                                TColors.grey, BlendMode.saturation),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.sm),
                      child: Image.asset(
                        icon.iconPath,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.xs),
              Text(
                icon.label,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: isSelected
                          ? TColors.primary
                          : dark
                              ? TColors.white
                              : TColors.textPrimary,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
