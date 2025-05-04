import '../../features/moodiary/models/icon_metadata.dart';
import 'icon_data/emotion_icons.dart';
import 'icon_data/activities_icons.dart';
import 'icon_data/expression_icons.dart';
import 'icon_data/weather_icons.dart';
export 'icon_data/emotion_icons.dart';
export 'icon_data/activities_icons.dart';
export 'icon_data/weather_icons.dart';
export 'icon_data/expression_icons.dart';

const predefinedIcons = <IconMetadata>[
  ...emotionIcons,
  ...weatherIcons,
  ...activitiesIcons,
  ...expressionIcons,
];
