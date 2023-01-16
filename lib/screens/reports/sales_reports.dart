// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element, use_build_context_synchronously

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/screens/reports/services/format_date.dart';
import 'package:bhatti_pos/screens/reports/services/pick_date_functions.dart';
import 'package:bhatti_pos/services/models/sales_report_data.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/login_widgets/processing_indicator.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/shared/widgets/reports_widgets/sales_reports_tile.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesReports extends StatefulWidget {
  // final String startingDate;
  // final String endingDate;
  const SalesReports({
    super.key,
    // required this.startingDate,
    // required this.endingDate,
  });

  @override
  State<SalesReports> createState() => _SalesReportsState();
}

class _SalesReportsState extends State<SalesReports> {
  DateTime? startingDate,
      endingDate; // These variables are used to store return values from date picker
  String? startDateToBeShown,
      endDateToBeShown; // these variables are created to display data on appbar
  int? noOfDays; // difference of days to display on appbar
  TextEditingController? _salesController;
  bool searching = false;

  @override
  void initState() {
    super.initState();
    _salesController = TextEditingController();
    ReportList.salesReportData.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _salesController!.dispose();
  }

  _getSalesReports(String startingDate, String endingDate) async {
    ReportList.salesReportData.clear();
    APIClient _apiClient = APIClient();

    List<dynamic> data = await _apiClient.getProductReport(
        UserData.userName!, startingDate, endingDate);

    // List of all objects of sales reports against the user name
    for (dynamic item in data) {
      SalesReportData reportData = SalesReportData.fromJson(item);
      ReportList.salesReportData.add(reportData);
    }
  }

  _fetchSalesReports() async {
    // Formatting selecting dates to be parseable in the api in month/date/year format
    String startDate = DateFormat("MM/dd/yyyy").format(startingDate!);
    String endDate = DateFormat("MM/dd/yyyy").format(endingDate!);

    // Calculating difference of days to display in the appbar..
    noOfDays = endingDate!.difference(startingDate!).inDays;

    LoginWidgets.processingIndicator(context);
    await _getSalesReports(startDate, endDate);
    LoginWidgets.closeProcessingIndicator(context);

    // Showing taost of loaded data
    showToast(
      ReportList.salesReportData.isEmpty
          ? "Nothing loaded"
          : ReportList.salesReportData.length == 1
              ? "1 item loaded"
              : "${ReportList.salesReportData.length} items are loaded",
      Colors.white,
    );

    // Formatting both dates in the date/month/year format with day name (three characters) to
    // display on the appbar
    startDateToBeShown =
        formatDateWithDayName(startingDate!, showCompleteDay: false);
    endDateToBeShown =
        formatDateWithDayName(endingDate!, showCompleteDay: false);

    // Setting both variables to null so that, if the user presses the button again, then he could perform
    // the operation from the beginning and thus can reselect dates, suppose if this step is not done then the
    // dates selected previously will be stored and the api will directly be called and thus the output will be
    // the same which is a bug...
    startingDate = null;
    endingDate = null;

    // this setState is called to refresh the screen to display the reports fetched
    setState(() {});
  }

  _salesReportsUi(CartProvider provider) {
    return ReportList.salesReportData.isEmpty ||
            searching && provider.getAllProductSalesReports.isEmpty
        ? NoData(
            text: searching
                ? "No Data"
                : startDateToBeShown == null
                    ? "Pick a range"
                    : "No reports found",
            additional: startDateToBeShown != null && !searching
                ? Text(
                    "Between $startDateToBeShown and\n$endDateToBeShown",
                    textAlign: TextAlign.center,
                    style: const TextStyle400FW12FS(textColor: greyTextColor),
                  )
                : null,
          )
        : ListView.builder(
            itemCount: searching
                ? provider.getAllProductSalesReports.length
                : ReportList.salesReportData.length,
            itemBuilder: (context, index) => SalesReportTile(
              report: searching
                  ? provider.getAllProductSalesReports[index]
                  : ReportList.salesReportData[index],
            ),
          );
  }

  _pickDatesAndFetchReports() async {
    startingDate ??= await pickDate(context, "Select a starting date");
    // if the starting date is null which means that no need to pick ending date i.e- cancel button was pressed
    if (startingDate == null) {
      showToast("Select dates to proceed ", Colors.white);
    }
    // this is the case that starting date is not null which means we can proceed to ending date
    else {
      endingDate ??= await pickDate(context, "Select an ending date");

      // case if the ending date is null or not selected, we cannot fetch data i.e- cancel button was pressed
      if (endingDate == null) {
        showToast("Select dates to proceed ", Colors.white);
      }
      // case if the ending date picked was a date older than starting date, a logical bug. still cant call api
      else if (startingDate!.difference(endingDate!).toString()[0] != "-" &&
          startingDate!.compareTo(endingDate!) != 0) {
        showToast("Invalid Selection", Colors.white);
      }

      // in this else block, since all logical and possible exceptions are handled so hitting the api to
      // fetch data
      else {
        _fetchSalesReports();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) => BaseScreen(
        onWillPop: () async {
          value.clearProductSalesReportFilters();
          searching = false;
          return true;
        },
        screenTitle: "Product Sales Reports",
        showSecondatyTitle:
            startDateToBeShown != null && endDateToBeShown != null
                ? true
                : false,
        secondaryTitle: startDateToBeShown != null && endDateToBeShown != null
            ? "From $startDateToBeShown to $endDateToBeShown ($noOfDays days)"
            : "",
        searchHintText: "Product name/ Amount",
        showSearch: ReportList.salesReportData.isEmpty ? false : true,
        showDivider: true,
        controller: _salesController!,
        onSubmit: (val) {
          value.clearProductSalesReportFilters();
          _salesController!.clear();
          searching = false;
        },
        onChanged: (val) {
          searching = true;
          value.filterProductSalesReports(val);
          if(val.isEmpty){
            value.clearProductSalesReportFilters();
          }
        },
        onTap: () {
          searching = false;
          value.clearProductSalesReportFilters();
          Navigator.pop(context);
        },
        widget: _salesReportsUi(value),
        floatingButtonIcon: Icons.date_range_rounded,
        showFloating: true,
        onFloatingPressed: () => _pickDatesAndFetchReports(),
      ),
    );
  }
}
