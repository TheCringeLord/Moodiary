import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';
import 'package:moodiary/common/widgets/dialog/bottom_dialog.dart';
import 'package:moodiary/features/moodiary/controllers/icon_block_controller.dart';
import 'package:moodiary/features/moodiary/models/icon_metadata.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/blocks/predefined_icon_picker.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/constants/sizes.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

class TAddIconButton extends StatelessWidget {
  final String blockId;

  const TAddIconButton({super.key, required this.blockId});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<IconMetadata>(
          backgroundColor: dark ? TColors.dark : TColors.white,
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TSizes.cardRadiusLg),
            ),
          ),
          builder: (_) => const TPredefinedIconPicker(),
        ).then((selectedIcon) {
          if (selectedIcon != null) {
            final controller = TextEditingController();
            final formKey = GlobalKey<FormState>();

            showModalBottomSheet(
              backgroundColor: dark ? TColors.dark : TColors.white,
              // ignore: use_build_context_synchronously
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => TBottomDialog(
                title: "Label Icon",
                controller: controller,
                formKey: formKey,
                maxLength: 12,
                hintText: "e.g. Excited",
                onConfirm: () {
                  if (formKey.currentState!.validate()) {
                    final label = controller.text.trim();

                    IconBlockController.instance.addIconToBlock(
                      blockId,
                      selectedIcon,
                      label,
                    );
                    Get.back(); // Close dialog
                  }
                },
              ),
            );
          }
        });
      },
      child: Column(
        children: [
          TRoundedContainer(
            width: 48,
            height: 48,
            radius: 24,
            backgroundColor: TColors.primary.withAlpha(100),
            child: const Icon(Iconsax.add, color: TColors.primary),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            "Add icon",
            style: Theme.of(context).textTheme.labelSmall!.apply(
                  color: TColors.primary,
                ),
          ),
        ],
      ),
    );
  }
}
