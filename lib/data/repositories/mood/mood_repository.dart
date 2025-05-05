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

  ///* Add new mood
  Future<void> createMood(MoodModel mood) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }
    try {
      await _db
          .collection('users')
          .doc(user.uid)
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }
    try {
      await _db
          .collection('users')
          .doc(user.uid)
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }
    try {
      await _db
          .collection('users')
          .doc(user.uid)
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }
    try {
      await _db
          .collection('users')
          .doc(user.uid)
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // no user → just emit empty list
      return Stream.value(<MoodModel>[]);
    }
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
        .orderBy('date')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => MoodModel.fromDocumentSnapshot(d)).toList());
  }

  ///* Get mood for a specific date
  Future<MoodModel?> getMoodByDate(DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final start = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    final end = Timestamp.fromDate(
      DateTime(date.year, date.month, date.day, 23, 59, 59),
    );

    final qs = await _db
        .collection('users')
        .doc(user.uid)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .limit(1)
        .get();
    if (qs.docs.isEmpty) return null;
    return MoodModel.fromDocumentSnapshot(qs.docs.first);
  }

  /// Remove all references of [iconId] from every array‐field in your moods
  Future<void> removeIconReferences(String iconId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Not authenticated");

    final col = _db.collection('users').doc(user.uid).collection('moods');
    final snapshot = await col.get();

    final batch = _db.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      Map<String, dynamic> updatedFields = {};
      bool hasChanged = false;

      // Remove from known predefined fields
      for (final field in [
        'emotions',
        'weather',
        'people',
        'hobbies',
        'work',
        'health',
        'chores',
        'relationship',
        'other',
      ]) {
        final icons = List<String>.from(data[field] ?? []);
        if (icons.contains(iconId)) {
          updatedFields[field] = FieldValue.arrayRemove([iconId]);
          hasChanged = true;
        }
      }

      // Remove from customBlocks
      if (data['customBlocks'] != null && data['customBlocks'] is Map) {
        final custom = Map<String, dynamic>.from(data['customBlocks']);
        final newCustom = <String, List<String>>{};
        bool customChanged = false;

        for (final entry in custom.entries) {
          final list = List<String>.from(entry.value);
          if (list.contains(iconId)) {
            list.remove(iconId);
            customChanged = true;
          }
          newCustom[entry.key] = list;
        }

        if (customChanged) {
          updatedFields['customBlocks'] = newCustom;
          hasChanged = true;
        }
      }

      // Commit update only if any field changed
      if (hasChanged) {
        batch.update(doc.reference, updatedFields);
      }
    }

    await batch.commit();
  }
}
