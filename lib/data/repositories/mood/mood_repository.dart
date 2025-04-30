import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../features/moodiary/models/mood_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class MoodRepository extends GetxController {
  static MoodRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool useMock = true;

  String get _userId {
    // Mock user ID for testing purposes (mock_user_123)
    if (useMock) return "Test Account 1";

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw "User not logged in";
    }
    return user.uid;
  }

  ///* Add new mood
  Future<void> createMood(MoodModel mood) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('moods')
          .doc(mood.id)
          .set(mood.toMap());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* Edit mood
  Future<void> updateMood(MoodModel mood) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('moods')
          .doc(mood.id)
          .update(mood.toMap());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* Delete mood
  Future<void> deleteMood(String moodId) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('moods')
          .doc(moodId)
          .delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* Function to update any field in a specific mood entry
  Future<void> updateMoodFields(
      String moodId, Map<String, dynamic> fieldsToUpdate) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('moods')
          .doc(moodId)
          .update(fieldsToUpdate);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again later.";
    }
  }

  ///* Get moods for calendar/report (filter by month)
  Stream<List<MoodModel>> getMoodsByMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    return _db
        .collection('users')
        .doc(_userId)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MoodModel.fromDocumentSnapshot(doc))
            .toList());
  }

  ///* Get mood for a specific date
  Future<MoodModel?> getMoodByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final querySnapshot = await _db
        .collection('users')
        .doc(_userId)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    return MoodModel.fromDocumentSnapshot(querySnapshot.docs.first);
  }
}
