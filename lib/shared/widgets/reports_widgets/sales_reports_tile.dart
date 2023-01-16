// ignore_for_file: use_build_context_synchronously

import 'package:bhatti_pos/services/models/sales_report_data.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class SalesReportTile extends StatelessWidget {
  final SalesReportData report;
  // final String contribution;
  const SalesReportTile({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius05,
        color: borderColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Space05v(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Product Id
              Text("Report PID: ${report.pID!}",
                  style: const TextStyle400FW12FS()),
              // Net Amount
              Text("PKR. ${report.netAmount!}",
                  style: const TextStyle600FW16FS()),
            ],
          ),
          const SizedBox(height: 03),
          //Product Name
          Text(report.productName!, style: const TextStyle600FW16FS()),
          const SizedBox(height: 03),
          //Quantity
          Text("Quantity: ${report.qty!}", style: const TextStyle400FW12FS()),
          const Space15v(),
        ],
      ),
    );
  }
}
