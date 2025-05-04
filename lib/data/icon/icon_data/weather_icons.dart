import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/enums.dart';
import '../../../features/moodiary/models/icon_metadata.dart';

const weatherIcons = <IconMetadata>[
  IconMetadata(
    id: 'sunny',
    label: 'Sunny',
    iconPath: TImages.sunny,
    category: IconCategory.weather,
  ),
  IconMetadata(
    id: 'rainy',
    label: 'Rainy',
    iconPath: TImages.rainy,
    category: IconCategory.weather,
  ),
  IconMetadata(
    id: 'cloudy',
    label: 'Cloudy',
    iconPath: TImages.cloudy,
    category: IconCategory.weather,
  ),
  IconMetadata(
    id: 'stormy',
    label: 'Stormy',
    iconPath: TImages.stormy,
    category: IconCategory.weather,
  ),
  IconMetadata(
    id: 'rainbow',
    label: 'Rainbow',
    iconPath: TImages.rainbow,
    category: IconCategory.weather,
  ),
];
