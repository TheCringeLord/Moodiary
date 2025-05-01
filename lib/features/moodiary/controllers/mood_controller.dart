import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/recording_block_controller.dart';

import 'package:moodiary/features/moodiary/screens/calendar/calendar.dart';
import '../../../data/repositories/mood/mood_repository.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../models/mood_model.dart';
import '../models/recording_block_model.dart';

class MoodController extends GetxController {
  static MoodController get instance => Get.find();

  ///* Selected main mood (emoji key)
  final RxString selectedMainMood = ''.obs;

  ///* All available recording blocks (emotions, people, etc.)
  final RxList<RecordingBlockModel> recordingBlocks =
      <RecordingBlockModel>[].obs;

  ///* Stores selected icon IDs per block (e.g. {'emotions': ['happy', 'relaxed']})
  final RxMap<String, RxList<String>> selectedIconsPerBlock =
      <String, RxList<String>>{}.obs;

  List<RecordingBlockModel> get activeBlocks =>
      recordingBlocks.where((block) => !block.isHidden).toList();

  ///* Select the main mood emoji
  void selectMainMood(String moodKey) {
    selectedMainMood.value = moodKey;
  }

  @override
  void onInit() {
    super.onInit();
    // loadDefaultBlocks();
  }

  ///* Clear all selections (called after saving)
  void clear() {
    selectedMainMood.value = '';
    selectedIconsPerBlock.clear();
  }

  ///* Save the mood log to Firestore
  Future<void> saveMood(DateTime date) async {
    // Validate main mood
    if (selectedMainMood.isEmpty) {
      TLoaders.warningSnackBar(
        title: "Oops!",
        message: "Please select a mood before saving.",
      );
      return;
    }

    try {
      // Show full screen loader
      TFullScreenLoader.openLoadingDialog(
          "Logging you in...", TImages.loadingJuggleAnimation);

      // Check internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Build MoodModel from selected data
      final mood = MoodModel(
        id: date.toIso8601String(),
        date: date,
        mainMood: selectedMainMood.value,
        emotions: getSelectedIcons("emotions"),
        people: getSelectedIcons("people"),
        weather: getSelectedIcons("weather"),
        hobbies: getSelectedIcons("hobbies"),
        work: getSelectedIcons("work"),
        health: getSelectedIcons("health"),
        chores: getSelectedIcons("chores"),
        relationship: getSelectedIcons("relationship"),
        other: getSelectedIcons("other"),
        customBlocks: getCustomBlocksMap(),
        sleepDuration: 0,
        photos: [],
      );

      // Save to Firestore
      await MoodRepository.instance.createMood(mood);

      // Cleanup
      clear();
      TFullScreenLoader.stopLoading();

      // Navigate to calendar
      Get.offAll(() => const CalendarScreen());

      // Show success
      TLoaders.successSnackBar(
        title: "Mood logged",
        message: "Your mood has been logged successfully.",
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh no!", message: e.toString());
    }
  }

  ///* Toggle selection of an icon within a block
  void toggleIcon(String blockId, String iconId) {
    if (!selectedIconsPerBlock.containsKey(blockId)) {
      selectedIconsPerBlock[blockId] = <String>[].obs;
    }
    final list = selectedIconsPerBlock[blockId]!;

    if (list.contains(iconId)) {
      list.remove(iconId);
    } else {
      list.add(iconId);
    }

    // trigger refresh (optional but useful)
    selectedIconsPerBlock.refresh();
  }

  ///* Check if an icon is selected
  bool isIconSelected(String blockId, String iconId) {
    return selectedIconsPerBlock[blockId]?.contains(iconId) ?? false;
  }

  ///* Return selected icons for a given block
  List<String> getSelectedIcons(String blockId) {
    return selectedIconsPerBlock[blockId]?.toList() ?? [];
  }

  ///* Extract only custom blocks and their selected icons
  Map<String, List<String>> getCustomBlocksMap() {
    return selectedIconsPerBlock.entries
        .where((entry) => !defaultBlockIds.contains(entry.key))
        .fold<Map<String, List<String>>>({}, (map, entry) {
      map[entry.key] = entry.value.toList();
      return map;
    });
  }

  ///* List of default (non-custom) block IDs
  static const List<String> defaultBlockIds = [
    "emotions",
    "people",
    "weather",
    "hobbies",
    "work",
    "health",
    "chores",
    "relationship",
    "other"
  ];

  void loadBlocks() async {
    await RecordingBlockController.instance.fetchBlocks();
    recordingBlocks.value = RecordingBlockController.instance.recordingBlocks;
  }
}
