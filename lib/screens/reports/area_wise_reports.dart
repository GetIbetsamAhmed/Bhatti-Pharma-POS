// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element
import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/services/models/area_wise_report_data.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class AreaWiseReports extends StatefulWidget {
  const AreaWiseReports({super.key});

  @override
  State<AreaWiseReports> createState() => _AreaWiseReportsState();
}

class _AreaWiseReportsState extends State<AreaWiseReports> {
  double totalAmount = 0.0;
  _getAreaWiseSalesReports() async {
    APIClient _apiClient = APIClient();
    ReportList.areaWiseReports.clear();
    List data = await _apiClient.getAreaWiseReport(UserData.userName!);

    if (data.isEmpty) {
      showToast("Nothing to display", Colors.white);
    } else {
      for (var item in data) {
        AreaWiseReportData report = AreaWiseReportData.fromJson(item);
        totalAmount += report.amount!;
        ReportList.areaWiseReports.add(report);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAreaWiseSalesReports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        } else {
          return _reportsUI();
        }
      },
    );
  }

  _reportsUI() {
    return BaseScreen(
      screenTitle: "Area Wise Reports",
      widget: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.64,
          width: MediaQuery.of(context).size.width,
          child: SfCircularChart(
            title: ChartTitle(text: UserData.userName!, textStyle: const TextStyle600FW16FS()),
            tooltipBehavior: TooltipBehavior(enable: true),

            legend: Legend(
              isVisible: true,
              position: LegendPosition.auto,
              padding: 04,
              alignment: ChartAlignment.center,
              iconHeight: 25,
              iconWidth: 25,
              textStyle:
                  const CustomTextStyle(size: 15, weight: FontWeight.w500),
              orientation: LegendItemOrientation.horizontal,
              // height: "100",
            ),
            series: <DoughnutSeries>[
              DoughnutSeries(
                // strokeColor: blueColor,
                radius: "140",
                dataSource: ReportList.areaWiseReports,
                xValueMapper: (data, index) => ReportList.areaWiseReports[index].customerAddress!,
                yValueMapper: (data, index) => ReportList.areaWiseReports[index].amount!,
                name: "Address: Amount",
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  alignment: ChartAlignment.near,
                  connectorLineSettings: ConnectorLineSettings(
                    width: 1,
                    type: ConnectorType.line,
                  ),
                  useSeriesColor: true,
                  // showCumulativeValues: true,
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
      onChanged: (val) {},
      showSearch: false,
      onWillPop: () async {
        return true;
      },
    );
  }
}

// BarChart(
//             BarChartData(
//               borderData: FlBorderData(
//                   border: const Border(
//                 top: BorderSide.none,
//                 right: BorderSide.none,
//                 left: BorderSide(width: 1),
//                 bottom: BorderSide(width: 1),
//               )),
//               groupsSpace: 05,
//               barGroups: [
//                 for (int item = 0; item < data.length; item++)
//                   BarChartGroupData(
//                     x: item,
//                     barRods: [
//                       BarChartRodData(
//                         toY: data[item]['amount'],
//                         width: 10,
//                         color: item.isEven ? Colors.green : blueColor,
//                         // color: Color),
//                       ),
//                     ],
//                   ),

//                 // BarChartGroupData(x: 7, barRods: [
//                 //   BarChartRodData(toY: 19, width: 15, color: Colors.amber),
//                 // ]),
//                 // BarChartGroupData(x: 8, barRods: [
//                 //   BarChartRodData(toY: 21, width: 15, color: Colors.amber),
//                 // ]),
//               ],
//             ),
//             swapAnimationDuration: const Duration(seconds: 5),
//             swapAnimationCurve: Curves.easeInCirc,
//           ),
