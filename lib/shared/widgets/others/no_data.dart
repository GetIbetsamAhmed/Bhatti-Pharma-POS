import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String text;
  final Widget? additional;
  const NoData({
    super.key,
    this.text = "No Data",
    this.additional,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.close,
            color: blueColor,
            size: 50,
          ),
          Text(
            text,
            style: const CustomTextStyle(
              size: 17,
              textColor: blueColor,
              weight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (additional!=null) additional!,
        ],
      ),
    );
  }
}
