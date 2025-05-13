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

  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw TFirebaseException('User not authenticated. Please log in.')
          .message;
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

  ///* Update only the block name
  Future<void> updateBlockName(String blockId, String newName) async {
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('recording_blocks')
          .doc(blockId)
          .update({'displayName': newName});
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
    print("✅ Default recording blocks created for user $_userId");
    print("========================================");
  }

  ///* Generate default block templates
  List<RecordingBlockModel> _generateDefaultBlocks() {
    final String iconPlaceholder = TImages.google;
    return [
      ///* Special blocks
      RecordingBlockModel(
        id: 'sleep',
        displayName: 'Sleep',
        isSpecial: true,
        isHidden: false,
        icons: [],
      ),
      RecordingBlockModel(
        id: 'notes',
        displayName: 'Today\'s Notes',
        isSpecial: true,
        isHidden: false,
        icons: [],
      ),

      ///* Regular blocks
      RecordingBlockModel(
        id: 'emotions',
        displayName: 'Emotions',
        icons: [
          RecordingIconModel(
              id: 'excited',
              label: 'Excited',
              iconPath: TImages.excited,
              isCustom: false),
          RecordingIconModel(
              id: 'relaxed',
              label: 'Relaxed',
              iconPath: TImages.relaxed,
              isCustom: false),
          RecordingIconModel(
              id: 'happy',
              label: 'Happy',
              iconPath: TImages.happyFlower,
              isCustom: false),
          RecordingIconModel(
              id: 'sleepy',
              label: 'Sleepy',
              iconPath: TImages.sleepy,
              isCustom: false),
          RecordingIconModel(
              id: 'hopeful',
              label: 'Hopeful',
              iconPath: TImages.hopeful,
              isCustom: false),
          RecordingIconModel(
              id: 'calm',
              label: 'Calm',
              iconPath: TImages.happyFlower2,
              isCustom: false),
          RecordingIconModel(
              id: 'proud',
              label: 'Proud',
              iconPath: TImages.proud,
              isCustom: false),
          RecordingIconModel(
              id: 'enthusiastic',
              label: 'Enthusiastic',
              iconPath: TImages.enthusiastic,
              isCustom: false),
          RecordingIconModel(
              id: 'refreshed',
              label: 'Refreshed',
              iconPath: TImages.refreshed,
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
            id: 'bowling',
            label: 'Bowling',
            iconPath: TImages.bowling,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'boxing',
            label: 'Boxing',
            iconPath: TImages.boxing,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'console',
            label: 'Console',
            iconPath: TImages.game1,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'arcade',
            label: 'Arcade',
            iconPath: TImages.game2,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'hockey',
            label: 'Hockey',
            iconPath: TImages.puck,
            isCustom: false,
          ),
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
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'family',
            label: 'Family',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'partner',
            label: 'Partner',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'coworkers',
            label: 'Coworkers',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
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
              iconPath: TImages.sunny,
              isCustom: false),
          RecordingIconModel(
              id: 'rainy',
              label: 'Rainy',
              iconPath: TImages.rainy,
              isCustom: false),
          RecordingIconModel(
              id: 'cloudy',
              label: 'Cloudy',
              iconPath: TImages.cloudy,
              isCustom: false),
          RecordingIconModel(
              id: 'stormy',
              label: 'Stormy',
              iconPath: TImages.stormy,
              isCustom: false),
          RecordingIconModel(
              id: 'rainbow',
              label: 'Rainbow',
              iconPath: TImages.rainbow,
              isCustom: false),
          RecordingIconModel(
              id: 'snowy',
              label: 'Snowy',
              iconPath: TImages.snowy,
              isCustom: false),
          RecordingIconModel(
              id: 'rainyNight',
              label: 'Rainy Night',
              iconPath: TImages.rainyNight,
              isCustom: false),
          RecordingIconModel(
              id: 'hail',
              label: 'Hail',
              iconPath: TImages.hail,
              isCustom: false),
          RecordingIconModel(
              id: 'foggy',
              label: 'Foggy',
              iconPath: TImages.foggy,
              isCustom: false),
          RecordingIconModel(
              id: 'windy',
              label: 'Windy',
              iconPath: TImages.windy,
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
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'tired',
            label: 'Tired',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'energetic',
            label: 'Energetic',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'headache',
            label: 'Headache',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
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
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'lazy',
            label: 'Lazy',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'overworked',
            label: 'Overworked',
            iconPath: iconPlaceholder,
            isCustom: false,
          ),
        ],
        isCustom: false,
        isHidden: false,
      ),
    ];
  }
}
