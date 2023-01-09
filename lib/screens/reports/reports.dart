// ignore_for_file: use_build_context_synchronously

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/screens/reports/area_wise_reports.dart';
import 'package:bhatti_pos/screens/reports/daily_reports.dart';
import 'package:bhatti_pos/screens/reports/sales_reports.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/widgets/others/screen_ratio.dart';
import 'package:bhatti_pos/shared/widgets/reports_widgets/report_tile.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  DateTime? startingDate, endingDate;
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onWillPop: () async {
        return true;
      },
      screenTitle: "Reports",
      widget: _reportsUI(context),
      onChanged: (val) {},
      showSearch: false,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  _reportsUI(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    return ScreenRatio(
      child: Column(
        children: [
          // Sales Reports
          ReportTile(
            imagePath: "assets/icons/business_reports.svg",
            text: "Product Sales Reports",
            onTap: () {
              Navigator.push(
                context,
                LTRPageRoute(
                  const SalesReports(),
                  100,
                ),
              );
            },
          ),
          const Space10v(),

          
          // Daily Reports
          ReportTile(
            imagePath: "assets/icons/sales_reports.svg",
            text: "Daily Sales Reports",
            onTap: () {
              Navigator.push(
                context,
                LTRPageRoute(
                  const DailyReports(),
                  100,
                ),
              );
            },
          ),
          const Space10v(),

          
          // Area-Wise Reports
          ReportTile(
            imagePath: "assets/icons/sales_reports.svg",
            text: "Area Wise Reports",
            onTap: () {
              Navigator.push(
                context,
                LTRPageRoute(
                  const AreaWiseReports(),
                  100,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
