
import 'package:flutter/material.dart';


import 'package:moodiary/app.dart';


Future<void> main() async {
  ///* Add Widgets Binding
  // final WidgetsBinding widgetsBinding =
  //     WidgetsFlutterBinding.ensureInitialized();

  ///*Init Local Storage
  // await GetStorage.init();

  ///* Await Native Splash
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  ///* Initialize Firebase and Authentication Repository
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  //     .then(
  //   (FirebaseApp value) => Get.put(AuthenticationRepository()),
  // );
 
  runApp(const App());
}
