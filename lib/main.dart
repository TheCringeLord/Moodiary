import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/app.dart';
import 'package:moodiary/features/moodiary/controllers/activity_customization_controller.dart';

void main() {
  ///TODO Add Widgets Binding

  ///TODO Init Local Storage

  ///TODO Await Native Splash

  ///TODO Initialize Firebase and Authentication Repository
  Get.put(ActivityCustomizationController());
  runApp(const App());
}
