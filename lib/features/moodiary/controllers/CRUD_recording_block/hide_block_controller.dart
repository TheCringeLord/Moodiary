import 'package:get/get.dart';
import '../../../../data/repositories/mood/recording_block_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../controllers/recording_block_controller.dart';

class HideBlockController extends GetxController {
  static HideBlockController get instance => Get.find();
  final recordingBlock = RecordingBlockController.instance;

  Future<void> toggleVisibility(String blockId, bool hidden) async {
    try {
      // 1. Update on Firebase
      await RecordingBlockRepository.instance
          .toggleBlockVisibility(blockId, hidden);

      // 2. Update local observable list
      final index = recordingBlock.recordingBlocks
          .indexWhere((block) => block.id == blockId);

      if (index != -1) {
        recordingBlock.recordingBlocks[index].isHidden = hidden;
        recordingBlock.recordingBlocks.refresh(); // 🔁 triggers UI update
      }

      // 3. Show success
      final status = hidden ? "hidden" : "unhidden";
      TLoaders.successSnackBar(
        title: hidden ? "Hidden" : "Visible",
        message:
            "${blockId[0].toUpperCase()}${blockId.substring(1).toLowerCase()} block has been $status.",
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }
}
