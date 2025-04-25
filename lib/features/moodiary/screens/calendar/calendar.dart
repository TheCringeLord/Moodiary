import 'package:flutter/material.dart';

import 'package:moodiary/features/moodiary/screens/calendar/widgets/custom_calendar.dart';

import 'package:moodiary/utils/constants/sizes.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // Calendar with fixed height instead of Expanded
                const SizedBox(
                  height: 630, // Adjust this value based on your needs
                  child: TCustomCalendar(),
                ),

                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
