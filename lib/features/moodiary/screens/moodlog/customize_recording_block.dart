import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/delete_block_controller.dart';
import 'package:moodiary/features/moodiary/controllers/CRUD_recording_block/hide_block_controller.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/tabs/active_block_tab.dart';
import 'package:moodiary/features/moodiary/screens/moodlog/widgets/customize_widgets/tabs/hidden_block_tab.dart';

import 'package:moodiary/utils/constants/colors.dart';
import 'package:moodiary/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/appbar/tabbar.dart';

import '../../controllers/icon_block_controller.dart';
import '../../controllers/CRUD_recording_block/create_block_controller.dart';
import '../../controllers/CRUD_recording_block/update_block_name_controller.dart';

class CustomizeRecordingBlockScreen extends StatelessWidget {
  const CustomizeRecordingBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    ///* Initialize RecordingBlock Controllers
    Get.put(UpdateBlockNameController());
    Get.put(HideBlockController());
    Get.put(DeleteBlockController());
    Get.put(CreateBlockController());

    ///* Initialize Icon Controllers
    Get.put(IconBlockController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: dark ? TColors.dark : TColors.light,
        appBar: TAppBar(
          title: Text(
            "Customize recording page",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
          centerTitle: true,
          bottom: const TTabBar(
            tabs: [
              Tab(text: "Active blocks"),
              Tab(text: "Hidden blocks"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ///* Active blocks tab
            TActiveBlockTab(),

            ///* Hidden blocks tab
            THiddenBlockTab(),
          ],
        ),
      ),
    );
  }
}
