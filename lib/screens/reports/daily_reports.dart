// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element, must_be_immutable, prefer_final_fields, use_build_context_synchronously

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/screens/reports/services/format_date.dart';
import 'package:bhatti_pos/screens/reports/services/pick_date_functions.dart';
import 'package:bhatti_pos/services/models/daily_report_data.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/login_widgets/processing_indicator.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/shared/widgets/reports_widgets/daily_reports_tile.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyReports extends StatefulWidget {
  // final DateTime date;
  const DailyReports({
    super.key,
    // required this.date,
  });

  @override
  State<DailyReports> createState() => _DailyReportsState();
}

class _DailyReportsState extends State<DailyReports> {
  _getAllDailyReports(date) async {
    date = DateFormat("MM/dd/yyyy").format(date);
    ReportList.dailyReports.clear();
    APIClient _apiClient = APIClient();

    if (kDebugMode) print("Reports are called with the date $date");
    List data = await _apiClient.getDailyReports(UserData.userName!, date);
    // list of all daily report object against a user name
    for (dynamic item in data) {
      DailyReportData reportData = DailyReportData.fromJson(item);
      ReportList.dailyReports.add(reportData);
    }

    // Showing taost of loaded data
    showToast(
      ReportList.dailyReports.isEmpty
          ? "Nothing loaded"
          : ReportList.dailyReports.length == 1
              ? "1 item loaded"
              : "${ReportList.dailyReports.length} items are loaded",
      Colors.white,
    );
  }

  bool searching = false;
  DateTime? date, previousDate;
  TextEditingController? _dailyReportsController;

  @override
  void initState() {
    _dailyReportsController = TextEditingController();
    ReportList.dailyReports.clear();
    super.initState();
  }

  @override
  void dispose() {
    _dailyReportsController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) => BaseScreen(
        onWillPop: () async {
          value.clearDailyReportsFilter();
          searching = false;
          return true;
        },
        screenTitle: "Daily Sales Reports",
        showSearch: ReportList.dailyReports.isEmpty ? false : true,
        showSecondatyTitle: date == null ? false : true,
        secondaryTitle: date != null ? formatDateWithDayName(date!) : "",
        controller: _dailyReportsController,
        searchHintText: "Customer name/ Area/ Order no",
        showDivider: true,
        onChanged: (val) {
          searching = true;
          value.filterDailyReports(val);
        },
        onSubmit: (val) {
          searching = false;
          value.clearDailyReportsFilter();
          _dailyReportsController!.clear();
        },
        onTap: () {
          value.clearDailyReportsFilter();
          searching = false;
          Navigator.pop(context);
        },
        widget: _dailyReports(context, date, value),
        showFloating: true,
        floatingButtonIcon: Icons.calendar_month,
        onFloatingPressed: () async {
          date = await pickDate(context, "Select a date to fetch values");
          // print(date);
          if (date != null) {
            if (previousDate != date) {
              LoginWidgets.processingIndicator(context);
              await _getAllDailyReports(date!);
              LoginWidgets.closeProcessingIndicator(context);
              setState(() {
                previousDate = date;
              });
            } else {
              customSnackBar("Date Already Selected", context);
            }
          } else {
            customSnackBar("Nothing Selected", context);
          }
        },
      ),
    );
  }

  _dailyReports(BuildContext context, DateTime? date, CartProvider value) {
    String dateAndDay = "";
    if (date != null) {
      dateAndDay = formatDateWithDayName(date);
    }
    return ReportList.dailyReports.isEmpty ||
            searching && value.getDailyReports.isEmpty
        ? NoData(
            text: searching
                ? "No Data"
                : date == null
                    ? "Select a date"
                    : "No Reports For",
            additional: Text(
              dateAndDay,
              style: const TextStyle400FW12FS(textColor: greyTextColor),
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: (searching
                    ? value.getDailyReports.length
                    : ReportList.dailyReports.length) +
                1,
            itemBuilder: (context, index) {
              if (searching && index < value.getDailyReports.length) {
                return DailyReportTile(
                  report: searching
                      ? value.getDailyReports[index]
                      : ReportList.dailyReports[index],
                );
              } else if (!searching && index < ReportList.dailyReports.length) {
                return DailyReportTile(
                  report: searching
                      ? value.getDailyReports[index]
                      : ReportList.dailyReports[index],
                );
              } else {
                return const SizedBox(height: 70);
              }
            },
          );
  }
}

customSnackBar(String text, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: blueColor,
      content: Text(text),
    ),
  );
}
