import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/moodlog.dart';
import 'package:moodiary/utils/popups/loaders.dart';

/// Controller for managing calendar logic and state.
class CalendarController extends GetxController {
  /// Tracks the currently viewed month.
  final Rx<DateTime> currentMonth = DateTime.now().obs;

  /// The date selected by the user.
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  /// The selected moods for each date.
  final RxMap<DateTime, String> selectedMoods = <DateTime, String>{}.obs;

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

  void saveMood(DateTime date, String mood) {
    // Store date without time component
    final normalizedDate = DateTime(date.year, date.month, date.day);
    selectedMoods[normalizedDate] = mood;
  }
  String? getMoodForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return selectedMoods[normalizedDate];
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
