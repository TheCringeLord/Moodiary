import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/features/moodiary/controllers/mood_controller.dart';
import 'package:moodiary/utils/popups/loaders.dart';

class TSleepPickerDialog extends StatelessWidget {
  const TSleepPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Record Sleep",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Obx(() {
            final totalMinutes = controller.sleepDurationInMinutes;
            final hours = totalMinutes ~/ 60;
            final minutes = totalMinutes % 60;
            final formatted = '${hours}hr ${minutes}min';
            return Column(
              children: [
                // Duration Display
                Text(
                  "Duration: $formatted",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                // Time Pickers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///TODO: Decorate TimePicker Widget
                    _TimePickerButton(
                      label: "Bedtime",
                      time: controller.sleepStart.value,
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: controller.sleepStart.value,
                        );
                        if (picked != null) {
                          controller.sleepStart.value = picked;
                        }
                      },
                    ),
                    _TimePickerButton(
                      label: "Wake Up",
                      time: controller.sleepEnd.value,
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: controller.sleepEnd.value,
                        );
                        if (picked != null) controller.sleepEnd.value = picked;
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final start = DateTime(
                  2000,
                  1,
                  1,
                  controller.sleepStart.value.hour,
                  controller.sleepStart.value.minute,
                );
                final end = DateTime(
                  2000,
                  1,
                  controller.sleepEnd.value.hour <
                          controller.sleepStart.value.hour
                      ? 2
                      : 1,
                  controller.sleepEnd.value.hour,
                  controller.sleepEnd.value.minute,
                );

                if (end.isBefore(start)) {
                  TLoaders.errorSnackBar(
                      title: "Invalid Time",
                      message: "Wake up time cannot be earlier than bedtime.");
                  return;
                }

                controller.isSleepSaved.value = true;

                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for time picker buttons
class _TimePickerButton extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onPressed;

  const _TimePickerButton({
    required this.label,
    required this.time,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(
          onPressed: onPressed,
          child: Text(
            time.format(context),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
