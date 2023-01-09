import 'package:bhatti_pos/screens/orders/order_details.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  const OrderTile({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, LTRPageRoute(OrderDetailsScreen(order: order), 100));
      },
      child: Column(
        children: [
          // const Space10v(),
          Container(
            padding: const EdgeInsets.all(10),
            // margin: const EdgeInsets.only(bottom: 10, left: 05, right: 05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(01),
              color: bgColor,
              border: border,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Space05v(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showTextWithTwoColors("", "${order.orderNo}"),
                    Text(
                      "PKR. ${order.netAmount!}",
                      style: const TextStyle600FW16FS(),
                    ),
                  ],
                ),
                const Space05v(),
                Text(
                  "${order.customerFirstName}",
                  style: const TextStyle600FW16FS(),
                ),
                Text(
                  order.area!,
                  style: const TextStyle400FW12FS(textColor: greyTextColor,),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${order.createDate}",
                    style: const TextStyle400FW12FS(
                      textColor: greyTextColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showTextWithTwoColors(String str1, String str2) {
    return Row(
      children: [
        Text(
          str1,
          style: const TextStyle400FW12FS(textColor: greyTextColor),
        ),
        Text(
          str2,
          style: const TextStyle400FW12FS(
              textColor: blueColor, weight: FontWeight.w600),
        ),
      ],
    );
  }
}
