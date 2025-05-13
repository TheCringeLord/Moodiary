import 'package:get/get.dart';

import 'package:moodiary/data/repositories/mood/recording_block_repository.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';
import 'package:moodiary/features/moodiary/models/recording_icon_mode.dart';

import '../../../data/repositories/mood/mood_repository.dart';
import '../models/icon_metadata.dart';
import '../models/recording_block_model.dart';

class IconBlockController extends GetxController {
  static IconBlockController get instance => Get.find();

  final recordingBlockController = RecordingBlockController.instance;
  final RxString selectedIconPath = ''.obs;
  final Rx<String> editingLabel = ''.obs;

  void setTempIconPath(String path) => selectedIconPath.value = path;

  void resetTempIconPath() => selectedIconPath.value = '';

  void setEditingLabel(String label) => editingLabel.value = label;

  void resetEditingLabel() => editingLabel.value = '';

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

  // In IconBlockController
  Future<void> updateIconLabel(
      String blockId, String iconId, String newLabel) async {
    try {
      // Get the RecordingBlockController
      final recordingCtrl = RecordingBlockController.instance;

      // Find block and icon
      final blockIndex =
          recordingCtrl.recordingBlocks.indexWhere((b) => b.id == blockId);
      if (blockIndex == -1) return;

      final block = recordingCtrl.recordingBlocks[blockIndex];
      final iconIndex = block.icons.indexWhere((i) => i.id == iconId);
      if (iconIndex == -1) return;

      // Create updated icon with new label but keep other properties
      final oldIcon = block.icons[iconIndex];
      final updatedIcon = RecordingIconModel(
        id: iconId,
        label: newLabel,
        iconPath: oldIcon.iconPath,
        isCustom: oldIcon.isCustom,
      );

      // Create new list of icons (important for reactivity)
      final newIcons = List<RecordingIconModel>.from(block.icons);
      newIcons[iconIndex] = updatedIcon;

      // Create new block with updated icons
      final updatedBlock = RecordingBlockModel(
        id: block.id,
        displayName: block.displayName,
        icons: newIcons,
        isHidden: block.isHidden,
        isSpecial: block.isSpecial,
      );

      // Update in the controller's list
      recordingCtrl.recordingBlocks[blockIndex] = updatedBlock;

      // Refresh the UI
      recordingCtrl.recordingBlocks.refresh();

      // Save to Firebase
      await RecordingBlockRepository.instance.updateBlock(updatedBlock);

      print("Icon label updated successfully to: $newLabel");
    } catch (e) {
      print("Error updating icon label: $e");
    }
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
