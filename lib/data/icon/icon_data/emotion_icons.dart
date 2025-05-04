import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/enums.dart';
import '../../../features/moodiary/models/icon_metadata.dart';

const emotionIcons = <IconMetadata>[
  IconMetadata(
      id: 'excited',
      label: 'Excited',
      iconPath: TImages.excited,
      category: IconCategory.emotion),
  IconMetadata(
      id: 'relaxed',
      label: 'Relaxed',
      iconPath: TImages.relaxed,
      category: IconCategory.emotion),
];
