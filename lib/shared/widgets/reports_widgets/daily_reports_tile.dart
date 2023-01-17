// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:bhatti_pos/screens/orders/order_details.dart';
import 'package:bhatti_pos/services/models/daily_report_data.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/models/order_details.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/login_widgets/processing_indicator.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DailyReportTile extends StatefulWidget {
  final DailyReportData report;
  const DailyReportTile({
    super.key,
    required this.report,
  });

  @override
  State<DailyReportTile> createState() => _DailyReportTileState();
}

class _DailyReportTileState extends State<DailyReportTile> {
  double subTotal = 0.0;
  double discountedPrice = 0.0;
  double totalAmount = 0.0;
  getOrderDetails() async {
    OrderList.orderDetails.clear();
    CartProvider provider = context.read<CartProvider>();
    provider.clearCarts();
    APIClient _apiClient = APIClient();
    List? data = await _apiClient.getOrderDetails(widget.report.orderNo!);
    if (data != null) {
      // The if block below is to check that either the order is comppleted or not
      // If the case completed, then the user will be navigated to the Order Detials Screen
      // If not the case, then the user will be navigated to the Edit Order screen which is basically the
      // cart screen with several modifications
      // Order Details Screen

      for (dynamic item in data) {
        OrderDetails details = OrderDetails.fromJson(item);
        OrderList.orderDetails.add(details);
        subTotal += (details.unitPrice! * details.quantity!);
        // discountedPrice += details.discount! * details.quantity!;
        discountedPrice += details.discount! * details.quantity!;
        totalAmount += details.payableAmount!;
      }
    }
    // totalAmount = subTotal - discountedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Step 1 => Fetching data
        LoginWidgets.processingIndicator(context);
        await getOrderDetails();
        LoginWidgets.closeProcessingIndicator(context);

        // Step 2 => Typecasting 
        // Report into order because OrderDetailsScreen requires an order to display
        // a name from it and show in the appbar
        Order order = Order(
          orderNo: widget.report.orderNo!,
          customerFirstName: widget.report.partyName!,
          netAmount: widget.report.cash,
          createDate: "", 
        );

        // Step 3 => Navigation to OrderDetailsScreen
        Navigator.push(
          context,
          LTRPageRoute(
            OrderDetailsScreen(
              order: order,
              subTotal: subTotal,
              discountedPrice: discountedPrice,
              totalAmount: totalAmount,
            ),
            100,
          ),
        );
      },
      child: Container(
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
                Text("PKR. ${widget.report.cash!}",
                    style: const TextStyle600FW16FS()),
              ],
            ),
            const SizedBox(height: 2),
            // Product Name here
            Text(
              widget.report.partyName!,
              style: const TextStyle600FW16FS(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            // Order Number
            Text("Order No: ${widget.report.orderNo!}",
                style: const TextStyle400FW12FS()),
            const Divider(
              height: 20,
              color: borderColor,
              thickness: 03,
            ),
            // Area Name
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.report.areaName!,
                style: const TextStyle400FW12FS(textColor: greyTextColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
