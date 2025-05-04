import 'package:moodiary/features/moodiary/screens/calendar/calendar.dart';
import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.dark : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withAlpha(15)
              : Colors.black.withAlpha(15),
          destinations: [
            const NavigationDestination(
              icon: Icon(Iconsax.calendar_1),
              label: "Home",
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.menu_board),
              label: "History",
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.chart_1),
              label: "Reports",
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.profile_circle),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const CalendarScreen(),
    const Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 117, 134),
    ),
    const Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 92, 134),
    ),
    const Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 75, 134),
    ),
  ];
}
