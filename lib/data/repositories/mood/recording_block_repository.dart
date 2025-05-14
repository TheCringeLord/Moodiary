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
  }

  ///* Generate default block templates
  List<RecordingBlockModel> _generateDefaultBlocks() {
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
      //! emotions;
      //! activities;
      //! people;
      //! weather;
      //! hobbies;
      //! work;
      //! health;
      //! chores;
      //! relationship;

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
            id: 'colleague',
            label: 'Colleague',
            iconPath: TImages.colleague,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'family',
            label: 'Family',
            iconPath: TImages.family,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'friends',
            label: 'Friends',
            iconPath: TImages.friends,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'romance',
            label: 'Romance',
            iconPath: TImages.romance,
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
            id: 'energetic',
            label: 'Energetic',
            iconPath: TImages.energyDrink,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'fever',
            label: 'Fever',
            iconPath: TImages.fever,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'headache',
            label: 'Headache',
            iconPath: TImages.headache,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'healthy',
            label: 'Healthy',
            iconPath: TImages.healthy,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'sleeping_in_bed',
            label: 'Sleeping in Bed',
            iconPath: TImages.sleepingInBed,
            isCustom: false,
          ),
        ],
        isCustom: false,
        isHidden: false,
      ),

      RecordingBlockModel(
        id: 'hobbies',
        displayName: 'Hobbies',
        icons: [
          RecordingIconModel(
            id: 'theater',
            label: 'Theater',
            iconPath: TImages.theater,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'drinks',
            label: 'Drinks',
            iconPath: TImages.drinks,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'drawing',
            label: 'Drawing',
            iconPath: TImages.drawing,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'movies',
            label: 'Movies',
            iconPath: TImages.movies,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'music',
            label: 'Music',
            iconPath: TImages.music,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'exercise',
            label: 'Exercise',
            iconPath: TImages.exercise,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'gardening',
            label: 'Gardening',
            iconPath: TImages.gardening,
            isCustom: false,
          ),
        ],
        isCustom: false,
        isHidden: false,
      ),

      RecordingBlockModel(
        id: 'work',
        displayName: 'Work',
        icons: [
          RecordingIconModel(
            id: 'briefcase',
            label: 'Work',
            iconPath: TImages.briefcase,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'group',
            label: 'Group',
            iconPath: TImages.group,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'computer',
            label: 'Computer',
            iconPath: TImages.computer,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'new_job',
            label: 'New Job',
            iconPath: TImages.newJob,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'teamwork',
            label: 'Teamwork',
            iconPath: TImages.teamwork,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'resume',
            label: 'Resume',
            iconPath: TImages.resume,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'work_from_home',
            label: 'Work From Home',
            iconPath: TImages.homeOffice,
            isCustom: false,
          ),
        ],
        isCustom: false,
        isHidden: false,
      ),

      RecordingBlockModel(
        id: 'chores',
        displayName: 'Chores',
        icons: [
          RecordingIconModel(
            id: 'clean_sparkle',
            label: 'Clean Sparkle',
            iconPath: TImages.cleanSparkle,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'clean_broom',
            label: 'Clean Broom',
            iconPath: TImages.cleanBroom,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'dirty_clothes',
            label: 'Dirty Clothes',
            iconPath: TImages.dirtyClothes,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'family_clothes',
            label: 'Family Clothes',
            iconPath: TImages.familyClothes,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'hand_wash',
            label: 'Hand Wash',
            iconPath: TImages.handWash,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'housekeeping',
            label: 'Housekeeping',
            iconPath: TImages.housekeeping,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'iron',
            label: 'Iron',
            iconPath: TImages.iron,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'laundry_bucket',
            label: 'Laundry Bucket',
            iconPath: TImages.laundryBucket,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'washing_machine',
            label: 'Washing Machine',
            iconPath: TImages.washingMachine,
            isCustom: false,
          ),
        ],
        isCustom: false,
        isHidden: false,
      ),

      RecordingBlockModel(
        id: 'relationship',
        displayName: 'Relationship',
        icons: [
          RecordingIconModel(
            id: 'couple',
            label: 'Couple',
            iconPath: TImages.couple,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'gift',
            label: 'Gift',
            iconPath: TImages.gift,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'important_event',
            label: 'Important Event',
            iconPath: TImages.importantEvent,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'in_love',
            label: 'In Love',
            iconPath: TImages.inLove,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'melting_heart',
            label: 'Melting Heart',
            iconPath: TImages.meltingHeart,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'relationship',
            label: 'Relationship',
            iconPath: TImages.relationshipIcon,
            isCustom: false,
          ),
          RecordingIconModel(
            id: 'trust',
            label: 'Trust',
            iconPath: TImages.trust,
            isCustom: false,
          ),
        ],
        isCustom: false,
        isHidden: false,
      ),
    ];
  }
}
