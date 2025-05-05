import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';
import 'package:moodiary/utils/popups/loaders.dart';

import '../../../../data/repositories/mood/recording_block_repository.dart';
import '../../../../data/repositories/mood/mood_repository.dart';

class DeleteBlockController extends GetxController {
  static DeleteBlockController get instance => Get.find();

  final recordingCtrl = RecordingBlockController.instance;

  Future<void> deleteBlock(String blockId) async {
    try {
      // Lookup the block
      final block =
          recordingCtrl.recordingBlocks.firstWhere((b) => b.id == blockId);

      if (block.isSpecial) {
        TLoaders.warningSnackBar(
          title: "Not allowed",
          message: "Special blocks cannot be deleted.",
        );
        return;
      }

      // 1. Cascade delete all icon references from moods
      for (final icon in block.icons) {
        await MoodRepository.instance.removeIconReferences(icon.id);
      }

      // 2. Delete the block from Firebase
      await RecordingBlockRepository.instance.deleteBlock(blockId);

      // 3. Remove from local state
      recordingCtrl.recordingBlocks.removeWhere((b) => b.id == blockId);

      TLoaders.successSnackBar(
        title: "Deleted",
        message: "Block and associated icon data deleted.",
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
