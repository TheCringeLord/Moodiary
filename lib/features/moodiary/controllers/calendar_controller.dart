import 'package:get/get.dart';

import 'package:moodiary/features/moodiary/screens/moodlog/moodlog.dart';
import 'package:moodiary/data/repositories/mood/mood_repository.dart';
import 'package:moodiary/utils/popups/loaders.dart';

import '../../../utils/constants/image_strings.dart';

import '../models/mood_model.dart';
import 'dart:async';

import 'package:moodiary/features/moodiary/controllers/mood_controller.dart';

class CalendarController extends GetxController {
  static CalendarController get instance => Get.find();

  ///* Variables
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxBool showMoodCard = false.obs;

  final RxList<MoodModel> monthlyMoods = <MoodModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Load moods when controller starts
    _bindStream();

    // Re-fetch moods whenever month changes
    ever(currentMonth, (_) => loadMoodsForCurrentMonth());
  }

  @override
  void onClose() {
    _moodStream?.cancel();

    super.onClose();
  }

  void _bindStream() {
    monthlyMoods.bindStream(
        MoodRepository.instance.getMoodsByMonth(currentMonth.value));
  }

  ///* Move to previous month
  void goToPreviousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
  }

  ///* Move to next month
  void goToNextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
  }

  ///* Get number of days in the current month
  int get daysInMonth {
    final nextMonth =
        DateTime(currentMonth.value.year, currentMonth.value.month + 1, 0);
    return nextMonth.day;
  }

  ///* Get the first day of the current month
  DateTime get firstDayOfMonth => DateTime(
        currentMonth.value.year,
        currentMonth.value.month,
        1,
      );

  ///* Get the weekday (0 = Sunday, 6 = Saturday) of the first day
  int get startWeekday => firstDayOfMonth.weekday % 7;

  ///* Get display text like "April 2025"
  String get monthYearText {
    return '${_monthNames[currentMonth.value.month - 1]} ${currentMonth.value.year}';
  }

  ///* (Optional) Get today's date to highlight
  DateTime get today => DateTime.now();

  ///* Month names for displaying
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  ///* Check if a given day is today
  bool isToday(int day) {
    final today = DateTime.now();
    final currentDate = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      day,
    );
    return today.year == currentDate.year &&
        today.month == currentDate.month &&
        today.day == currentDate.day;
  }

  bool isSelectedDay(int day) {
    final sel = selectedDate.value;
    if (sel == null) return false;
    final cm = currentMonth.value;
    return sel.year == cm.year && sel.month == cm.month && sel.day == day;
  }

  ///* Check if a given day is selected
  void selectDay(int day) {
    final date = getDateFromDay(day);

    if (date.isAfter(DateTime.now())) {
      selectedDate.value = null;
      return;
    }

    selectedDate.value = date;
  }

  ///* Jump to a specific month and year
  void jumpToMonth(int month, int year) {
    currentMonth.value = DateTime(year, month);
  }

  ///* function to reset the calendar to today
  void resetToToday() {
    final now = DateTime.now();
    currentMonth.value = DateTime(now.year, now.month);
    selectDay(now.day);
  }

  ///* Get the date from the selected day
  DateTime getDateFromDay(int day) =>
      DateTime(currentMonth.value.year, currentMonth.value.month, day);

  ///* Check if the given day is valid for the current month
  bool isValidDay(int day) => day > 0 && day <= daysInMonth;

  ///!----------- Mood Logging -----------!///
  Future<void> onDateTileTap(int day) async {
    final date = getDateFromDay(day);

    if (date.isAfter(DateTime.now())) {
      TLoaders.warningSnackBar(
        title: "Oops!",
        message: "You cannot select future dates.",
      );
      return;
    }

    //* Always select & show the card
    selectedDate.value = date;
    showMoodCard.value = true;

    //* Look up an existing MoodModel in this month’s cache
    final existing = monthlyMoods.firstWhereOrNull((m) =>
        m.date.year == date.year &&
        m.date.month == date.month &&
        m.date.day == date.day);

    if (existing != null) {
      //* We have a logged mood → print all its info and stop
      print("=== Mood details for $date ===");
      print("Main Mood     : ${existing.mainMood}");
      print("Sleep Duration: ${existing.sleepDuration} min");
      print("Notes         : ${existing.note}");
      print("Emotions      : ${existing.emotions}");
      print("People        : ${existing.people}");
      print("Weather       : ${existing.weather}");
      print("Hobbies       : ${existing.hobbies}");
      print("Work          : ${existing.work}");
      print("Health        : ${existing.health}");
      print("Chores        : ${existing.chores}");
      print("Relationship  : ${existing.relationship}");
      print("Other         : ${existing.other}");
      print("Custom Blocks : ${existing.customBlocks}");
      print("Photos        : ${existing.photos}");
      print("===============================");
      return;
    }

    //* No existing mood → navigate to log screen
    await Get.to(() => MoodlogScreen(selectedDate: date))
        ?.then((_) => Get.delete<MoodController>());
  }

  ///!----------- Mood Logging END -----------!///

  ///* Load moods for the current month
  void loadMoodsForCurrentMonth() {
    final month = currentMonth.value;

    _moodStream?.cancel();

    _moodStream = MoodRepository.instance
        .getMoodsByMonth(month)
        .listen((moods) => monthlyMoods.value = moods);
  }

  StreamSubscription? _moodStream;

  ///* Get the mood for a specific day
  String? getMoodEmojiForDay(int day) {
    final date = getDateFromDay(day);

    final mood = monthlyMoods.firstWhereOrNull(
      (m) =>
          m.date.year == date.year &&
          m.date.month == date.month &&
          m.date.day == date.day,
    );

    switch (mood?.mainMood) {
      case 'veryHappy':
        return TImages.veryHappy;
      case 'happy':
        return TImages.happy;
      case 'neutral':
        return TImages.neutral;
      case 'unhappy':
        return TImages.unHappy;
      case 'sad':
        return TImages.sad;
      default:
        return null;
    }
  }
}
