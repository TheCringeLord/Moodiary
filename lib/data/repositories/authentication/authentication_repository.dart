import 'package:moodiary/features/authentication/screens/login/login.dart';
import 'package:moodiary/features/authentication/screens/onboarding/onboarding.dart';

import 'package:moodiary/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:moodiary/utils/exceptions/format_exceptions.dart';
import 'package:moodiary/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../features/authentication/screens/signup/verify_email.dart';
import '../../../features/moodiary/controllers/calendar_controller.dart';
import '../../../features/moodiary/controllers/detail_controller.dart';
import '../../../features/moodiary/controllers/mood_controller.dart';
import '../../../features/moodiary/controllers/recording_block_controller.dart';
import '../../../features/moodiary/controllers/report_controller.dart';
import '../../../navigation_menu.dart';
import '../mood/recording_block_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  ///* Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  ///* Get Authenticated User data
  User? get authUser => _auth.currentUser;

  ///* Called from main.dart on app launch
  @override
  void onReady() {
    // Remove the splash screen
    FlutterNativeSplash.remove();
    // Call the screen redirect function to navigate to the appropriate screen
    try {
      screenRedirect();
    } catch (e) {
      debugPrint("❌ screenRedirect error: $e");
      Get.offAll(() => const OnboardingScreen()); // fallback screen
    }
  }

  ///* Function to Show Relevant Screen
  Future<void> screenRedirect() async {
    final user = _auth.currentUser;
 

    if (user != null) {
      
      if (user.emailVerified) {
     
        Get.offAll(() => const NavigationMenu());
      } else {
   
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      // read (or default) the flag
      final isFirstTime = await deviceStorage.read('isFirstTime') ?? true;
   

      if (isFirstTime) {
        // first time → show onboarding, then mark as done
   
        await deviceStorage.write('isFirstTime', false);
        Get.offAll(() => const OnboardingScreen());
      } else {
        // not first time → go to login
      
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  ///!--------------------------------Email and Password Sign in----------------------------------!///

  ///* [Email Authentication] - Sign In
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* [Email Authentication] - Sign Up
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ✅ Create default blocks for new user
      if (userCredential.user != null) {
        await RecordingBlockRepository.instance.createDefaultBlocks();
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* [ReAuthenticate] - Reauthenticate User

  ///* [Email Verification] - Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* [Email Authentication] - Forgot Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///!--------------------------------Federated identity and Social Sign-in----------------------------------!///
  ///* [Google] - Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      //Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      //Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      //Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      //Sign in the user with the credential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print("Something went wrong: $e");
      return null;
    }
  }

  ///* [Facebook] - Facebook
  ///!-------------------------------- ./end Federated identity and Social Sign-in----------------------------------!///
  ///* [Logout User] - Valid for any authentication
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (Get.isRegistered<ReportController>()) {
        final reportCtrl = Get.find<ReportController>();
        reportCtrl.moods.clear();
        reportCtrl.annualMoods.clear(); // Clear annual data to prevent leakage
        reportCtrl.spots.clear();
        reportCtrl.avgBedtime.value = null;
        reportCtrl.avgWakeUp.value = null;
      }
      // Clear user-specific controllers
      Get.delete<CalendarController>();
      Get.delete<MoodController>();
      Get.delete<DetailController>();
      Get.delete<ReportController>();
      Get.delete<RecordingBlockController>();
      // Navigate to login screen
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* [Delete User] - Remove user from Firebase Auth and Firestore
}
