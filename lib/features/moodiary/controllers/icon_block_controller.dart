import 'package:get/get.dart';

import 'package:moodiary/data/repositories/mood/recording_block_repository.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';
import 'package:moodiary/features/moodiary/models/recording_icon_mode.dart';

import '../../../data/repositories/mood/mood_repository.dart';
import '../models/icon_metadata.dart';

class IconBlockController extends GetxController {
  static IconBlockController get instance => Get.find();

  final recordingBlockController = RecordingBlockController.instance;
  final RxString selectedIconPath = ''.obs;

  void setTempIconPath(String path) => selectedIconPath.value = path;

  void resetTempIconPath() => selectedIconPath.value = '';

  void addIconToBlock(
      String blockId, IconMetadata baseIcon, String customLabel) {
    final index = recordingBlockController.recordingBlocks
        .indexWhere((block) => block.id == blockId);
    if (index == -1) return;

    final block = recordingBlockController.recordingBlocks[index];

    final newIcon = RecordingIconModel(
      id: "${baseIcon.id}_${DateTime.now().millisecondsSinceEpoch}",
      label: customLabel,
      iconPath: baseIcon.iconPath,
      isCustom: true,
    );

    block.icons.add(newIcon);
    recordingBlockController.recordingBlocks.refresh();

    // Persist to Firebase
    RecordingBlockRepository.instance.updateBlock(block);
  }

  void updateIconLabel(String blockId, String iconId, String newLabel) {
    // 👉 use recordingBlocks here, not hiddenBlocks
    final index = recordingBlockController.recordingBlocks
        .indexWhere((b) => b.id == blockId);
    if (index == -1) return;

    // now update on the same list
    final icons = recordingBlockController.recordingBlocks[index].icons;
    final iconIndex = icons.indexWhere((i) => i.id == iconId);
    if (iconIndex == -1) return;

    icons[iconIndex].label = newLabel;
    recordingBlockController.recordingBlocks.refresh();

    RecordingBlockRepository.instance
        .updateBlock(recordingBlockController.recordingBlocks[index]);
  }

  Future<void> deleteIconFromBlock(String blockId, String iconId) async {
    final index = recordingBlockController.recordingBlocks
        .indexWhere((b) => b.id == blockId);
    if (index == -1) return;

    final block = recordingBlockController.recordingBlocks[index];
    block.icons.removeWhere((i) => i.id == iconId);

    // Persist deletion on block
    await RecordingBlockRepository.instance.updateBlock(block);

    // Cascade-remove from all mood logs
    await MoodRepository.instance.removeIconReferences(iconId);

    // Refresh UI
    recordingBlockController.recordingBlocks.refresh();
  }
}
