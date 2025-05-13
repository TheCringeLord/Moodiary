import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:moodiary/common/widgets/appbar/appbar.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/tab/annual_report_tab.dart';
import 'package:moodiary/features/moodiary/screens/reports/widgets/tab/monthly_report_tab.dart';

import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/recording_block_controller.dart';
import '../../controllers/report_controller.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    Get.put(ReportController());
    Get.put(RecordingBlockController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: dark ? TColors.dark : TColors.light,
        appBar: TAppBar(
          title: Text(
            "Report",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          centerTitle: true,
          bottom: const TTabBar(
            tabs: [
              Tab(text: "Monthly"),
              Tab(text: "Annual"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ///* Active blocks tab
            TMonthlyReportTab(),

            ///* Hidden blocks tab
            TAnnualReportTab(),
          ],
        ),
      ),
    );
  }
}
