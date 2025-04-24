import 'package:flutter/material.dart';

import 'package:moodiary/features/moodiary/screens/calendar/widgets/custom_calendar.dart';

import 'package:moodiary/utils/constants/sizes.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: TAppBar(
      //   title: Text("Calendar"),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const Expanded(child: TCustomCalendar()),
            ],
          ),
        ),
      ),
    );
  }
}
