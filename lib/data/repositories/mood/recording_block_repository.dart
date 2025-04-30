import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/moodiary/models/recording_block_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class RecordingBlockRepository extends GetxController {
  static RecordingBlockRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  bool useMock = true;

  String get _userId {
    if (useMock) return "Test Account 1";

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw "User not logged in";
    }
    return user.uid;
  }

  /// Create a new block
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

  /// Update an existing block
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

  /// Delete block by ID
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

  /// Get all blocks (active + hidden)
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

  /// Toggle block visibility
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
}
