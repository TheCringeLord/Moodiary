import 'package:get/get.dart';

import '../screens/moodlog/moodlog.dart';

class CalendarController extends GetxController {
  static CalendarController get instance => Get.find();

  ///* Variables
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final Rxn<int> selectedDay = Rxn<int>();

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

  ///* Check if a given day is selected
  void selectDay(int day) {
    selectedDay.value = day;
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
  void startMoodLogging(int dayNumber) {
    //TODO: Add a check if already logged mood for the day display a mood card else go to mood log screen
    selectDay(dayNumber);

    final selectedDate = getDateFromDay(dayNumber);

    Get.to(() => MoodlogScreen(selectedDate: selectedDate));
  }
}
