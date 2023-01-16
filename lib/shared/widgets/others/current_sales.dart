import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CurrentSalesWidget extends StatelessWidget {
  final String currentSales;
  const CurrentSalesWidget({
    super.key,
    required this.currentSales,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Space05v(),
          // const Text("Today's Gross Sales",
          //     style: CustomTextStyle(size: 16, textColor: greyTextColor)),
          // const Space10v(),
          Container(
            height: currentSales.length <= 10
                ? 150
                : currentSales.length <= 12
                    ? 180
                    : currentSales.length <= 13
                        ? 200
                        : 230,
            width: currentSales.length <= 10
                ? 150
                : currentSales.length <= 12
                    ? 180
                    : currentSales.length <= 13
                        ? 200
                        : 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: blueColor, width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("PKR",
                      style:
                          CustomTextStyle(size: 16, textColor: greyIconColor)),
                  Text(
                    currentSales,
                    style: const CustomTextStyle(
                      size: 22,
                      textColor: blueColor,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Gross Sales",
                    style: CustomTextStyle(
                      size: currentSales.length >= 12 ? 16 : 13,
                      textColor: greyIconColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Space15v(),
        ],
      ),
    );
  }
}
