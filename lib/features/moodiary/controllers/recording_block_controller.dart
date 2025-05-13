import 'package:get/get.dart';
import '../../../data/repositories/mood/recording_block_repository.dart';

import '../models/recording_block_model.dart';

import '../../../utils/popups/loaders.dart';
import '../models/recording_icon_mode.dart';

class RecordingBlockController extends GetxController {
  static RecordingBlockController get instance => Get.find();

  final RxList<RecordingBlockModel> recordingBlocks =
      <RecordingBlockModel>[].obs;
  final RxBool isLoading = false.obs;

  List<RecordingBlockModel> get specialBlocks =>
      recordingBlocks.where((b) => b.isSpecial && !b.isHidden).toList();

  List<RecordingBlockModel> get normalBlocks =>
      recordingBlocks.where((b) => !b.isSpecial && !b.isHidden).toList();

  ///* Load all recording blocks (active + hidden)
  Future<void> fetchBlocks() async {
    try {
      isLoading.value = true;
      final blocks = await RecordingBlockRepository.instance.fetchAllBlocks();

      // If no blocks exist, create defaults
      if (blocks.isEmpty) {
        await RecordingBlockRepository.instance.createDefaultBlocks();
        final newBlocks =
            await RecordingBlockRepository.instance.fetchAllBlocks();
        recordingBlocks.assignAll(newBlocks);
      } else {
        recordingBlocks.assignAll(blocks);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  ///* Toggle block visibility (hide or unhide)
  Future<void> toggleVisibility(String blockId, bool isHidden) async {
    try {
      await RecordingBlockRepository.instance
          .toggleBlockVisibility(blockId, isHidden);
      await fetchBlocks(); // Refresh the list after change
    } catch (e) {
      TLoaders.errorSnackBar(
          title: "Failed to update visibility", message: e.toString());
    }
  }

  ///* Utility: Get only active blocks
  List<RecordingBlockModel> get activeBlocks =>
      recordingBlocks.where((block) => !block.isHidden).toList();

  ///* Utility: Get only hidden blocks
  List<RecordingBlockModel> get hiddenBlocks =>
      recordingBlocks.where((block) => block.isHidden == true).toList();

  ///* Function to create a new block
  Future<void> createNewBlock(String displayName) async {
    try {
      final id = displayName.toLowerCase().replaceAll(' ', '_');
      final newBlock = RecordingBlockModel(
        id: id,
        displayName: displayName,
        icons: [],
        isCustom: true,
        isHidden: false,
      );

      await RecordingBlockRepository.instance.createBlock(newBlock);
      recordingBlocks.add(newBlock);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  Map<String, RecordingIconModel> get allIconMetadataById {
    final Map<String, RecordingIconModel> map = {};
    for (final block in recordingBlocks) {
      for (final icon in block.icons) {
        map[icon.id] = icon;
      }
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();

    fetchBlocks();
  }
}
