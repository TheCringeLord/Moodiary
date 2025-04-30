import 'package:get/get.dart';

import '../data/repositories/mood/mood_repository.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MoodRepository());
    Get.put(NetworkManager());
  }
}
