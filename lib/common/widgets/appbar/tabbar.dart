import 'package:moodiary/utils/constants/colors.dart';

import 'package:moodiary/utils/device/device_utility.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TTabBar({
    super.key,
    required this.tabs,
  });
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? TColors.dark : TColors.light,
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
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
