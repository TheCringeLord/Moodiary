import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moodiary/utils/constants/image_strings.dart';

import '../../../features/moodiary/models/recording_block_model.dart';
import '../../../features/moodiary/models/recording_icon_mode.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class RecordingBlockRepository extends GetxController {
  static RecordingBlockRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  bool useMock = false;

  String get _userId {
    if (useMock) return "Test Account 1";

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw "User not logged in";
    }
    return user.uid;
  }

  ///* Create a new block
  Future<void> createBlock(RecordingBlockModel block) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('recording_blocks')
          .doc(block.id)
          .set(block.toMap());
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

  ///* Update an existing block
  Future<void> updateBlock(RecordingBlockModel block) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('recording_blocks')
          .doc(block.id)
          .update(block.toMap());
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

  ///* Delete block by ID
  Future<void> deleteBlock(String blockId) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('recording_blocks')
          .doc(blockId)
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

  ///* Get all blocks (active + hidden)
  Future<List<RecordingBlockModel>> fetchAllBlocks() async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(_userId)
          .collection('recording_blocks')
          .get();

      return snapshot.docs
          .map((doc) => RecordingBlockModel.fromMap(doc.data()))
          .toList();
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

  ///* Toggle block visibility
  Future<void> toggleBlockVisibility(String blockId, bool hidden) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('recording_blocks')
          .doc(blockId)
          .update({'isHidden': hidden});
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

  ///* Create default blocks for new users
  Future<void> createDefaultBlocks() async {
    final existing = await fetchAllBlocks();

    if (existing.isNotEmpty) return; // avoid overwriting

    final defaultBlocks = _generateDefaultBlocks();
    final batch = _db.batch();
    for (final block in defaultBlocks) {
      final ref = _db
          .collection('users')
          .doc(_userId)
          .collection('recording_blocks')
          .doc(block.id);
      batch.set(ref, block.toMap());
    }
    await batch.commit();
    print("========================================");
    print("✅ Default recording blocks created for user ${_userId}");
    print("========================================");
  }

  ///* Generate default block templates
  List<RecordingBlockModel> _generateDefaultBlocks() {
    final String iconPlaceholder = TImages.google;
    return [
      RecordingBlockModel(
        id: 'emotions',
        displayName: 'Emotions',
        icons: [
          RecordingIconModel(
              id: 'happy',
              label: 'Happy',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'sad',
              label: 'Sad',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'angry',
              label: 'Angry',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'excited',
              label: 'Excited',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'anxious',
              label: 'Anxious',
              iconPath: iconPlaceholder,
              isCustom: false),
        ],
        isCustom: false,
        isHidden: false,
      ),
      RecordingBlockModel(
        id: 'activities',
        displayName: 'Activities',
        icons: [
          RecordingIconModel(
              id: 'workout',
              label: 'Workout',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'reading',
              label: 'Reading',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'cooking',
              label: 'Cooking',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'cleaning',
              label: 'Cleaning',
              iconPath: iconPlaceholder,
              isCustom: false),
        ],
        isCustom: false,
        isHidden: false,
      ),
      RecordingBlockModel(
        id: 'people',
        displayName: 'People',
        icons: [
          RecordingIconModel(
              id: 'friends',
              label: 'Friends',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'family',
              label: 'Family',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'partner',
              label: 'Partner',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'coworkers',
              label: 'Coworkers',
              iconPath: iconPlaceholder,
              isCustom: false),
        ],
        isCustom: false,
        isHidden: false,
      ),
      RecordingBlockModel(
        id: 'weather',
        displayName: 'Weather',
        icons: [
          RecordingIconModel(
              id: 'sunny',
              label: 'Sunny',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'rainy',
              label: 'Rainy',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'cloudy',
              label: 'Cloudy',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'storm',
              label: 'Storm',
              iconPath: iconPlaceholder,
              isCustom: false),
        ],
        isCustom: false,
        isHidden: false,
      ),
      RecordingBlockModel(
        id: 'health',
        displayName: 'Health',
        icons: [
          RecordingIconModel(
              id: 'sick',
              label: 'Sick',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'tired',
              label: 'Tired',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'energetic',
              label: 'Energetic',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'headache',
              label: 'Headache',
              iconPath: iconPlaceholder,
              isCustom: false),
        ],
        isCustom: false,
        isHidden: false,
      ),
      RecordingBlockModel(
        id: 'sleep',
        displayName: 'Sleep',
        icons: [
          RecordingIconModel(
              id: 'well_rest',
              label: 'Well Rested',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'bad_sleep',
              label: 'Bad Sleep',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'nap',
              label: 'Nap',
              iconPath: iconPlaceholder,
              isCustom: false),
        ],
        isCustom: false,
        isHidden: false,
      ),
      RecordingBlockModel(
        id: 'productivity',
        displayName: 'Productivity',
        icons: [
          RecordingIconModel(
              id: 'focused',
              label: 'Focused',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'lazy',
              label: 'Lazy',
              iconPath: iconPlaceholder,
              isCustom: false),
          RecordingIconModel(
              id: 'overworked',
              label: 'Overworked',
              iconPath: iconPlaceholder,
              isCustom: false),
        ],
        isCustom: false,
        isHidden: false,
      ),
    ];
  }
}
