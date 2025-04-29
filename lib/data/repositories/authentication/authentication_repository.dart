import 'package:moodiary/features/authentication/screens/login/login.dart';
import 'package:moodiary/features/authentication/screens/onboarding/onboarding.dart';

import 'package:moodiary/features/moodiary/screens/calendar/calendar.dart';

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
    screenRedirect();
  }

  ///* Function to Show Relevant Screen
  screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      Get.offAll(() => const CalendarScreen());
    } else {
      //Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      //If the user is not logged in and it's the first time, navigate to the onboarding screen
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() =>
              const LoginScreen()) // Navigate to the login screen if not first time
          : Get.offAll(() =>
              const OnboardingScreen()); // Navigate to the onboarding screen if first time
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
      return await _auth.createUserWithEmailAndPassword(
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
