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
import '../models/recording_icon_mode.dart';

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

  ///* Select the main mood emoji
  void selectMainMood(String moodKey) {
    selectedMainMood.value = moodKey;
  }

  @override
  void onInit() {
    super.onInit();
    loadDefaultBlocks();
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

  Future<void> loadBlocks() async {
    // Fetch blocks from Firestore or create defaults
    await RecordingBlockController.instance.createDefaultBlocksIfEmpty();
    recordingBlocks.assignAll(
      RecordingBlockController.instance.activeBlocks,
    );
  }

  void loadDefaultBlocks() {
    recordingBlocks.value = [
      RecordingBlockModel(
        id: 'emotions',
        displayName: 'Emotions',
        icons: [
          RecordingIconModel(
              id: 'excited', label: 'Excited', iconPath: TImages.google),
          RecordingIconModel(
              id: 'relaxed', label: 'Relaxed', iconPath: TImages.google),
          RecordingIconModel(id: 'sad', label: 'Sad', iconPath: TImages.google),
          RecordingIconModel(
              id: 'angry', label: 'Angry', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'people',
        displayName: 'People',
        icons: [
          RecordingIconModel(
              id: 'friends', label: 'Friends', iconPath: TImages.google),
          RecordingIconModel(
              id: 'family', label: 'Family', iconPath: TImages.google),
          RecordingIconModel(
              id: 'coworkers', label: 'Coworkers', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'weather',
        displayName: 'Weather',
        icons: [
          RecordingIconModel(
              id: 'sunny', label: 'Sunny', iconPath: TImages.google),
          RecordingIconModel(
              id: 'rainy', label: 'Rainy', iconPath: TImages.google),
          RecordingIconModel(
              id: 'cloudy', label: 'Cloudy', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'hobbies',
        displayName: 'Hobbies',
        icons: [
          RecordingIconModel(
              id: 'reading', label: 'Reading', iconPath: TImages.google),
          RecordingIconModel(
              id: 'gaming', label: 'Gaming', iconPath: TImages.google),
          RecordingIconModel(
              id: 'cooking', label: 'Cooking', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'work',
        displayName: 'Work',
        icons: [
          RecordingIconModel(
              id: 'productive', label: 'Productive', iconPath: TImages.google),
          RecordingIconModel(
              id: 'meeting', label: 'Meeting', iconPath: TImages.google),
          RecordingIconModel(
              id: 'deadline', label: 'Deadline', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'health',
        displayName: 'Health',
        icons: [
          RecordingIconModel(
              id: 'tired', label: 'Tired', iconPath: TImages.google),
          RecordingIconModel(
              id: 'sick', label: 'Sick', iconPath: TImages.google),
          RecordingIconModel(
              id: 'energetic', label: 'Energetic', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'chores',
        displayName: 'Chores',
        icons: [
          RecordingIconModel(
              id: 'cleaning', label: 'Cleaning', iconPath: TImages.google),
          RecordingIconModel(
              id: 'laundry', label: 'Laundry', iconPath: TImages.google),
          RecordingIconModel(
              id: 'shopping', label: 'Shopping', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'relationship',
        displayName: 'Relationship',
        icons: [
          RecordingIconModel(
              id: 'happy', label: 'Happy', iconPath: TImages.google),
          RecordingIconModel(
              id: 'argument', label: 'Argument', iconPath: TImages.google),
          RecordingIconModel(
              id: 'bonding', label: 'Bonding', iconPath: TImages.google),
        ],
      ),
      RecordingBlockModel(
        id: 'other',
        displayName: 'Other',
        icons: [
          RecordingIconModel(
              id: 'travel', label: 'Travel', iconPath: TImages.google),
          RecordingIconModel(
              id: 'event', label: 'Event', iconPath: TImages.google),
          RecordingIconModel(
              id: 'misc', label: 'Misc.', iconPath: TImages.google),
        ],
      ),
    ];
  }

  List<RecordingBlockModel> get activeBlocks =>
      recordingBlocks.where((block) => !block.isHidden).toList();
}
