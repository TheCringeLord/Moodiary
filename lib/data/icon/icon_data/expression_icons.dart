import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/enums.dart';
import '../../../features/moodiary/models/icon_metadata.dart';

const expressionIcons = <IconMetadata>[
  IconMetadata(
      id: 'bored',
      label: 'Bored',
      iconPath: TImages.bored,
      category: IconCategory.expression),
  IconMetadata(
      id: 'crazy',
      label: 'Crazy',
      iconPath: TImages.crazy,
      category: IconCategory.expression),
  IconMetadata(
      id: 'neutral',
      label: 'Neutral',
      iconPath: TImages.neutralExpression,
      category: IconCategory.expression),
  IconMetadata(
      id: 'smile',
      label: 'Smile',
      iconPath: TImages.smile,
      category: IconCategory.expression),
];
