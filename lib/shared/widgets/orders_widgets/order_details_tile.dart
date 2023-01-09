import 'package:bhatti_pos/services/models/order_details.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:flutter/material.dart';

class OrderDetailTile extends StatelessWidget {
  final OrderDetails order;
  final String orderCreateDate;
  const OrderDetailTile({
    super.key,
    required this.order,
    required this.orderCreateDate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const Space10v(),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10, left: 05, right: 05),
              decoration: BoxDecoration(
                borderRadius: borderRadius05,
                color: bgColor,
                border: border,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Space05v(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circle Containing first letter of product name
                      CircleAvatar(
                        radius: 25,
                        child: Text(
                          order.productName![0],
                          style: const CustomTextStyle(
                            textColor: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Space05h(),
                      // Product name
                      Expanded(
                        child: Text(
                          order.productName!.toString(),
                          style: const TextStyle600FW16FS(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Space05v(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _valueContainer(
                        context,
                        "Units Ordered",
                        order.quantity!.toStringAsFixed(2),
                      ),
                      _verticalDivider(context),
                      _valueContainer(
                        context,
                        "Unit Price (PKR)",
                        
                        regulateNumber(double.parse(order.unitPrice!.toStringAsFixed(2))),
                      ),
                      _verticalDivider(context),
                      _valueContainer(
                        context,
                        "Discount per unit",
                        "${order.percentageDiscount!.toStringAsFixed(2)}%",
                      ),
                      _verticalDivider(context),
                      _valueContainer(
                        context,
                        "Payable Amount",
                        regulateNumber(double.parse(order.payableAmount!.toStringAsFixed(2))),
                        
                      ),
                    ],
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      orderCreateDate,
                      style: const TextStyle400FW12FS(
                        textColor: greyTextColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // COD Tag
        Positioned(
          top: 0,
          right: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 05),
            decoration: BoxDecoration(
              color: tagBlueColor,
              borderRadius: borderRadius100,
            ),
            child: const Text(
              "Cash On Delivery",
              style: TextStyle400FW12FS(textColor: blueColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 44 * MediaQuery.of(context).textScaleFactor,
      color: greyTextColor.withOpacity(.15),
    );
  }

  Widget _valueContainer(BuildContext context, String label, String value) {
    double widthRatio = 0.2;

    return SizedBox(
      // color: Colors.amber,
      // height: 50,
      width: MediaQuery.of(context).size.width * widthRatio,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(height: 02),
          Text(
            label,
            style: const CustomTextStyle(size: 11, textColor: greyTextColor),
            textAlign: TextAlign.center,
          ),
          const Space05v(),
          Text(
            value,
            style: const CustomTextStyle(
              weight: FontWeight.w700,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}
