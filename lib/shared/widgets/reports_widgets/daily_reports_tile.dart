import 'package:bhatti_pos/services/models/daily_report_data.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyReportTile extends StatelessWidget {
  final DailyReportData report;
  const DailyReportTile({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius05,
        color: borderColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image
              SvgPicture.asset(
                "assets/icons/health.svg",
                height: 40,
                width: 40,
              ),

              // Price Here
              Text("PKR. ${report.cash!}", style: const TextStyle600FW16FS()),
            ],
          ),
          const SizedBox(height: 2),
          // Product Name here
          Text(
            report.partyName!,
            style: const TextStyle600FW16FS(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          // Order Number
          Text("Order No: ${report.orderNo!}", style: const TextStyle400FW12FS()),
          const Divider(
            height: 20,
            color: borderColor,
            thickness: 03,
          ),
          // Area Name
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              report.areaName!,
              style: const TextStyle400FW12FS(textColor: greyTextColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
