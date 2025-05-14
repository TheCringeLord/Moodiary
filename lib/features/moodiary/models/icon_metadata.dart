import 'package:moodiary/features/moodiary/models/recording_icon_mode.dart';
import '../../../data/icon/index.dart';
import '../../../utils/constants/enums.dart';

///* Represents a single predefined icon with metadata.
class IconMetadata {
  final String id;
  final String label;
  final String iconPath;
  final IconCategory category;

  const IconMetadata({
    required this.id,
    required this.label,
    required this.iconPath,
    required this.category,
  });
}

///* Converts IconMetadata to your app's RecordingIconModel
RecordingIconModel fromPredefined(IconMetadata icon) {
  return RecordingIconModel(
    id: icon.id,
    label: icon.label,
    iconPath: icon.iconPath,
    isCustom: false,
  );
}

///* Get all unique icon categories (for tab view)
List<IconCategory> getIconCategories() {
  return predefinedIcons.map((icon) => icon.category).toSet().toList();
}

///* Get all icons that belong to a given category
List<IconMetadata> getIconsByCategory(IconCategory category) {
  return predefinedIcons.where((icon) => icon.category == category).toList();
}

String iconCategoryToString(IconCategory category) {
  switch (category) {
    case IconCategory.emotion:
      return 'Emotion';
    case IconCategory.weather:
      return 'Weather';
    case IconCategory.people:
      return 'People';
    case IconCategory.activities:
      return 'Activities';
    case IconCategory.health:
      return 'Health';
    case IconCategory.productivity:
      return 'Productivity';
    case IconCategory.expression:
      return 'Expression';
    case IconCategory.chores:
      return 'Chores';
    case IconCategory.relationship:
      return 'Relationship';
    case IconCategory.hobbies:
      return 'Hobbies';
    case IconCategory.work:
      return 'Work';
    case IconCategory.other:
      return 'Other';
  }
}
