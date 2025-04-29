import 'package:get/get.dart';
import 'package:moodiary/features/moodiary-old/screens/moodlog/moodlog.dart';
import 'package:moodiary/utils/popups/loaders.dart';

/// Controller for managing calendar logic and state.
class CalendarController extends GetxController {
  static CalendarController get instance => Get.find();

  /// Tracks the currently viewed month.
  final Rx<DateTime> currentMonth = DateTime.now().obs;

  /// The date selected by the user.
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  /// The selected moods for each date.
  final RxMap<DateTime, String> selectedMoods = <DateTime, String>{}.obs;

  /// Store both mood and activities
  final RxMap<DateTime, Map<String, dynamic>> moodData =
      <DateTime, Map<String, dynamic>>{}.obs;

  /// Go to previous month.
  void goToPreviousMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month - 1);
  }

  /// Go to next month.
  void goToNextMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month + 1);
  }

  void saveMood(DateTime date, String mood,
      [Map<String, List<int>>? activities]) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Create a data structure to store mood and activities
    final data = {
      'mood': mood,
      'activities': activities ?? <String, List<int>>{},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    moodData[normalizedDate] = data;
    update();
  }

  String? getMoodForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return moodData[normalizedDate]?['mood'] as String?;
  }

  Map<String, List<int>>? getActivitiesForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return moodData[normalizedDate]?['activities'] as Map<String, List<int>>?;
  }

  void deleteMood(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    moodData.remove(normalizedDate);
    update();
  }

  /// Selects a day.
  void selectDate(DateTime date) {
    // Check if the tapped date is in the future
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final tappedDate = DateTime(date.year, date.month, date.day);

    // Allow selection only if the date is today or earlier
    if (tappedDate.isAfter(todayDate)) {
      TLoaders.warningSnackBar(
          title: "Oops!", message: "You can't select a future date.");
      return;
    }
    selectedDate.value = date;

    // Go to next page to Mood log
    Get.to(() => MoodlogScreen());
  }

  /// Checks if the given date is today.
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  /// Checks if the given date is the selected date.
  bool isSelected(DateTime date) {
    final selected = selectedDate.value;
    return selected != null &&
        selected.year == date.year &&
        selected.month == date.month &&
        selected.day == date.day;
  }
}
