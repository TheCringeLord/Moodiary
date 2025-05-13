import 'package:moodiary/utils/constants/colors.dart';

import 'package:moodiary/utils/device/device_utility.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TTabBar({
    super.key,
    required this.tabs,
    this.backgroundColor = TColors.light,
  });
  final List<Widget> tabs;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? TColors.dark : backgroundColor,
      child: TabBar(
        tabs: tabs,
        isScrollable: false,
        labelPadding: EdgeInsets.zero,
        indicatorWeight: 1,
        indicatorColor: TColors.primary,
        unselectedLabelColor: TColors.darkerGrey,
        labelColor: dark ? TColors.white : TColors.primary,
        tabAlignment: TabAlignment.fill,
        dividerColor: Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
