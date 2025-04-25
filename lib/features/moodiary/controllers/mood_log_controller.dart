import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/screens/calendar/calendar.dart';

import '../../../utils/popups/loaders.dart';
import '../models/mood_model.dart';
import 'calendar_controller.dart';

class MoodlogController extends GetxController {
  static MoodlogController get instance => Get.find();

  // For mood selection
  final RxInt selectedMoodIndex = (-1).obs;
  final List<Mood> moods = Mood.defaultMoods;

  // For activity selection
  final RxSet<String> expandedCategories = <String>{}.obs;
  final RxMap<String, List<int>> selectedActivities = <String, List<int>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Start with all categories expanded
    expandedCategories.addAll(["Emotions", "People", "Weather"]);
  }

  void toggleCategory(String category) {
    if (expandedCategories.contains(category)) {
      expandedCategories.remove(category);
    } else {
      expandedCategories.add(category);
    }
  }

  bool isActivitySelected(String category, int index) {
    return selectedActivities[category]?.contains(index) ?? false;
  }

  void toggleActivity(String category, int index) {
    if (!selectedActivities.containsKey(category)) {
      selectedActivities[category] = <int>[];
    }

    final activities = selectedActivities[category]!;
    if (activities.contains(index)) {
      activities.remove(index);
    } else {
      activities.add(index);
    }

    selectedActivities[category] = activities;
  }

  void selectMood(int index) {
    if (index < 0 || index >= moods.length) return;
    selectedMoodIndex.value = selectedMoodIndex.value == index ? -1 : index;
  }

  Future<void> saveMood(DateTime date) async {
    if (selectedMoodIndex.value == -1) {
      TLoaders.warningSnackBar(
        title: "No Mood Selected",
        message: "Please select a mood first",
      );
      return;
    }

    try {
      final selectedMood = moods[selectedMoodIndex.value];
      final calendarController = Get.find<CalendarController>();

      // Save mood and activities
      calendarController.saveMood(
        date,
        selectedMood.value,
        selectedActivities
            .map((key, value) => MapEntry(key, List<int>.from(value))),
      );

      // Debug print all selected activities
      print('===== SAVED MOOD DATA =====');
      print('Date: ${date.toString()}');
      print('Mood: ${selectedMood.value}');
      print('Selected Activities:');
      selectedActivities.forEach((category, indices) {
        print('  $category: $indices');
      });
      print('==========================');

      // Reset selection
      selectedMoodIndex.value = -1;

      // Show success message and navigate back to calendar
      TLoaders.successSnackBar(
        title: "Success",
        message: "Mood saved successfully!",
      );

      Get.off(() =>
          const CalendarScreen()); // Replace with your calendar screen class
    } catch (e) {
      print('Error saving mood: $e');
      TLoaders.errorSnackBar(
          title: "Error", message: "Failed to save mood: ${e.toString()}");
    }
  }
}
