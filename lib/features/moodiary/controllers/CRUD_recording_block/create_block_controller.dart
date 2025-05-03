import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';
import 'package:moodiary/utils/popups/loaders.dart';
import '../../../../data/repositories/mood/recording_block_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';

import '../../models/recording_block_model.dart';

class CreateBlockController extends GetxController {
  static CreateBlockController get instance => Get.find();

  final TextEditingController blockName = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final recordingBlock = RecordingBlockController.instance;

  Future<void> createBlock() async {
    try {
      TFullScreenLoader.openLoadingDialog(
        "Creating new block...",
        TImages.docerAnimation,
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final newBlock = RecordingBlockModel(
        id: blockName.text.trim().toLowerCase().replaceAll(' ', '_'),
        displayName: blockName.text.trim(),
        icons: [],
        isHidden: false,
      );

      await RecordingBlockRepository.instance.createBlock(newBlock);
      recordingBlock.recordingBlocks.add(newBlock);
      recordingBlock.recordingBlocks.refresh();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: "Created",
        message: "New recording block added successfully.",
      );

      Get.back();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
