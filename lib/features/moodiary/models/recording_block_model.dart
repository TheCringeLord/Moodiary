import 'package:flutter/foundation.dart';
import 'package:moodiary/features/moodiary/models/recording_icon_mode.dart';

class RecordingBlockModel {
  final String id; // e.g. "emotions", "people"
  String displayName; // User-facing name, editable
  List<RecordingIconModel> icons; // List of icons in this block
  bool isCustom; // If this is a user-created block
bool isHidden;
  RecordingBlockModel({
    required this.id,
    required this.displayName,
    required this.icons,
    this.isCustom = false,
    this.isHidden = false,
  });

  ///* Convert model to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'icons': icons.map((e) => e.toMap()).toList(),
      'isCustom': isCustom,
      'isHidden': isHidden,
    };
  }

  ///* Create model from Firestore document
  factory RecordingBlockModel.fromMap(Map<String, dynamic> map) {
    return RecordingBlockModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      icons: (map['icons'] as List<dynamic>)
          .map((icon) => RecordingIconModel.fromMap(icon))
          .toList(),
      isCustom: map['isCustom'] ?? false,
      isHidden: map['isHidden'] ?? false,
    );
  }

  ///* Clone with updated values
  RecordingBlockModel copyWith({
    String? displayName,
    List<RecordingIconModel>? icons,
    bool? isCustom,
  }) {
    return RecordingBlockModel(
      id: id,
      displayName: displayName ?? this.displayName,
      icons: icons ?? this.icons,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  ///* Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordingBlockModel &&
          other.id == id &&
          other.displayName == displayName &&
          listEquals(other.icons, icons) &&
          other.isCustom == isCustom;

  @override
  int get hashCode =>
      id.hashCode ^ displayName.hashCode ^ icons.hashCode ^ isCustom.hashCode;

  @override
  String toString() =>
      'RecordingBlockModel(id: $id, displayName: $displayName, isCustom: $isCustom, icons: $icons)';
}
