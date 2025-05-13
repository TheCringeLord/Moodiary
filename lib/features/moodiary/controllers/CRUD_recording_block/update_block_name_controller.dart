import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';
import 'package:moodiary/features/moodiary/models/recording_block_model.dart';
import 'package:moodiary/utils/helpers/network_manager.dart';
import 'package:moodiary/utils/popups/full_screen_loader.dart';
import 'package:moodiary/utils/popups/loaders.dart';
import 'package:moodiary/utils/constants/image_strings.dart';

import '../../../../data/repositories/mood/recording_block_repository.dart';

class UpdateBlockNameController extends GetxController {
  static UpdateBlockNameController get instance => Get.find();

  final TextEditingController blockName = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final recordingBlock = RecordingBlockController.instance;

  /// The currently selected block
  late RecordingBlockModel selectedBlock;

  /// Initialize the controller with existing block info
  void initializeName(RecordingBlockModel block) {
    selectedBlock = block;
    blockName.text = block.displayName;
  }

  /// Update block name in Firebase
  Future<void> updateBlockName() async {
    try {
      // 1. Show loader
      TFullScreenLoader.openLoadingDialog(
        "Updating block name...",
        TImages.docerAnimation,
      );
 
      // 2. Check network
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // 3. Validate form
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      final trimmedName = blockName.text.trim();

      // 4. Write to Firebase
      await RecordingBlockRepository.instance.updateBlockName(
        selectedBlock.id,
        trimmedName,
      );

      // 5. Update local observable list
      final index = recordingBlock.recordingBlocks
          .indexWhere((b) => b.id == selectedBlock.id);
      if (index != -1) {
        recordingBlock.recordingBlocks[index].displayName = trimmedName;
        recordingBlock.recordingBlocks.refresh(); // 🔁 triggers UI update
      }

      // 6. Close loader
      TFullScreenLoader.stopLoading();

      // 7. Close dialog
      Get.back(result: true);

      //8.  Success feedback
      TLoaders.successSnackBar(
        title: "Updated",
        message: "Recording block name updated successfully!",
      );


      Get.back();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
