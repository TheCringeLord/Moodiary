import 'package:get/get.dart';

import 'package:moodiary/features/moodiary/screens/calendar/calendar.dart';
import '../../../data/repositories/mood/mood_repository.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../models/mood_model.dart';

class MoodController extends GetxController {
  static MoodController get instance => Get.find();

  final RxString selectedMainMood = ''.obs;

  void selectMainMood(String moodKey) {
    selectedMainMood.value = moodKey;
  }

  void clear() {
    selectedMainMood.value = '';
  }

  Future<void> saveMood(DateTime date) async {
    ///* Show warning
    if (selectedMainMood.isEmpty) {
      TLoaders.warningSnackBar(
        title: "Oops!",
        message: "Please select a mood before saving.",
      );
      return;
    }

    try {
      ///* Start Loading
      TFullScreenLoader.openLoadingDialog(
          "Logging you in...", TImages.loadingJuggleAnimation);

      ///* Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        TFullScreenLoader.stopLoading();
        return;
      }

      ///TODO: Validate mood data before saving

      ///* Create a new MoodModel instance with the selected mood and date
      final mood = MoodModel(
        id: date.toIso8601String(),
        date: date,
        mainMood: selectedMainMood.value,
        emotions: [],
        people: [],
        weather: [],
        hobbies: [],
        work: [],
        health: [],
        chores: [],
        relationship: [],
        other: [],
        customBlocks: {},
        sleepDuration: 0,
        photos: [],
      );

      ///* Save the mood to the repository
      await MoodRepository.instance.createMood(mood);

      clear();

      ///* Remove Loader
      TFullScreenLoader.stopLoading();

      Get.offAll(() => const CalendarScreen());

      TLoaders.successSnackBar(
        title: "Mood logged",
        message: "Your mood has been logged successfully.",
      );
    } catch (e) {
      ///* remove loader
      TFullScreenLoader.stopLoading();

      ///*Show some generic error message
      TLoaders.errorSnackBar(title: "Oh no!", message: e.toString());
    }
  }
}
