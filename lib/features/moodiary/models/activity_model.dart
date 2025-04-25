import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum IconType { asset, iconsax }

class ActivityIcon {
  final String id;
  final String name;
  final IconType type;
  final String? assetPath;
  final IconData? iconData;
  final Color? color;
  final int index;

  const ActivityIcon({
    required this.id,
    required this.name,
    required this.type,
    required this.index,
    this.assetPath,
    this.iconData,
    this.color,
  });

  // Factory constructors for convenience
  factory ActivityIcon.asset({
    required String id,
    required String name,
    required String path,
    required int index,
    Color? color,
  }) {
    return ActivityIcon(
      id: id,
      name: name,
      type: IconType.asset,
      assetPath: path,
      index: index,
      color: color,
    );
  }

  factory ActivityIcon.iconsax({
    required String id,
    required String name,
    required IconData icon,
    required int index,
    Color? color,
  }) {
    return ActivityIcon(
      id: id,
      name: name,
      type: IconType.iconsax,
      iconData: icon,
      index: index,
      color: color,
    );
  }

  // Helper to build the actual icon widget
  Widget buildIcon({double size = 24.0}) {
    switch (type) {
      case IconType.asset:
        return Image.asset(
          assetPath!,
          width: size,
          height: size,
          color: color,
          fit: BoxFit.contain,
        );
      case IconType.iconsax:
        return Icon(
          iconData,
          size: size,
          color: color,
        );
    }
  }
}

class ActivityCategory {
  static List<ActivityIcon> getEmotionIcons() => [
        ActivityIcon.iconsax(
          id: 'calm',
          name: 'Calm',
          icon: Iconsax.emoji_happy,
          index: 2,
        ),
        // Add more icons as needed
      ];

  static List<ActivityIcon> getPeopleIcons() => [
        ActivityIcon.iconsax(
          id: 'family',
          name: 'Family',
          icon: Iconsax.people,
          index: 0,
        ),
        ActivityIcon.iconsax(
          id: 'friends',
          name: 'Friends',
          icon: Iconsax.user_octagon,
          index: 1,
        ),
        // Add more icons as needed
      ];

  static List<ActivityIcon> getWeatherIcons() => [
        ActivityIcon.iconsax(
          id: 'sunny',
          name: 'Sunny',
          icon: Iconsax.sun_1,
          index: 0,
        ),
        ActivityIcon.iconsax(
          id: 'cloudy',
          name: 'Cloudy',
          icon: Iconsax.cloud,
          index: 1,
        ),
        // Add more icons as needed
      ];
}
