// moodlog_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../utils/constants/image_strings.dart'; // Add this import

class MoodlogScreen extends StatelessWidget {
  final controller = Get.put(CalendarController());

  MoodlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Your Mood')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Mood for ${controller.selectedDate}',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            _buildMoodGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodGrid() {
    final moods = [
      {'icon': TImages.veryHappy, 'value': 'veryHappy'},
      {'icon': TImages.happy, 'value': 'happy'},
      {'icon': TImages.neutral, 'value': 'neutral'},
      {'icon': TImages.unHappy, 'value': 'unHappy'},
      {'icon': TImages.sad, 'value': 'sad'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) => ElevatedButton(
        onPressed: () => _handleMoodSelection(moods[index]['value']!),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          backgroundColor: Colors.white,
        ),
        child: Image.asset(
          moods[index]['icon']!,
          height: 40,
          width: 40,
        ),
      ),
    );
  }

  void _handleMoodSelection(String mood) {
    controller.saveMood(controller.selectedDate.value!, mood);
    print('Mood selected: $mood for date: ${controller.selectedDate.value}');
    Get.back();
  }
}
