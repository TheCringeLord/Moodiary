import 'package:get/get.dart';
import 'package:moodiary/data/repositories/mood/recording_block_repository.dart';

import '../data/repositories/mood/mood_repository.dart';

import '../features/moodiary/controllers/calendar_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MoodRepository());
    Get.put(RecordingBlockRepository());
    Get.put(CalendarController());
    Get.put(NetworkManager());
  }
}
