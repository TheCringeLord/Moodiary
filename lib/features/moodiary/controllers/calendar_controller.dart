import 'package:get/get.dart';

import 'package:moodiary/utils/constants/image_strings.dart';

import '../../../data/repositories/mood/mood_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/mood_model.dart';
import '../screens/moodlog/moodlog.dart';
import 'dart:async';

class CalendarController extends GetxController {
  static CalendarController get instance => Get.find();

  ///* Variables
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  final RxList<MoodModel> monthlyMoods = <MoodModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Load moods when controller starts
    loadMoodsForCurrentMonth();

    // Re-fetch moods whenever month changes
    ever(currentMonth, (_) => loadMoodsForCurrentMonth());
  }

  @override
  void onClose() {
    _moodStream?.cancel();
    super.onClose();
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
  DateTime getDateFromDay(int day) {
    return DateTime(currentMonth.value.year, currentMonth.value.month, day);
  }

  ///* Check if the given day is valid for the current month
  bool isValidDay(int day) => day > 0 && day <= daysInMonth;

  ///* Start mood logging for a specific day
  void startMoodLogging(int dayNumber) async {
    // compute the actual DateTime for this tile
    final date = getDateFromDay(dayNumber);

    // 1) Prevent logging future dates
    if (date.isAfter(DateTime.now())) {
      TLoaders.warningSnackBar(
        title: "Oh no!",
        message: "You cannot select future dates.",
      );
      return;
    }

    // store the selection
    selectedDate.value = date;

    // 2) Check if a mood already exists
    final existingMood = await MoodRepository.instance.getMoodByDate(date);
    if (existingMood != null) {
      TLoaders.successSnackBar(
        title: "Main mood: ${existingMood.mainMood}",
        message:
            "You have already logged your mood for ${date.toIso8601String()}",
      );
      return;
    }

    // 3) No existing mood → navigate to log screen
    Get.to(() => MoodlogScreen(selectedDate: date));
  }

  ///* Load moods for the current month
  void loadMoodsForCurrentMonth() {
    final month = currentMonth.value;

    // Clear previous subscription
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
