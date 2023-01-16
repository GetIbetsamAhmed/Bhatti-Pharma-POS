import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/others/logo.dart';
import 'package:flutter/material.dart';

class LogoWithMessage extends StatelessWidget {
  final String message1;
  final String message2;
  final double logoSize;
  final double height;
  const LogoWithMessage({
    super.key,
    this.logoSize = 150,
    required this.message1,
    required this.message2,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // Bhatti Pharmacy logo displayed
        Logo(size: logoSize + scaleFactor),

        SizedBox(height: 4 + scaleFactor),

        // First message, in the login case it will be
        // Welcome Back
        Text(
          message1,
          style: CustomTextStyle(
            size: 24 - scaleFactor,
            weight: FontWeight.w600,
            textColor: blueColor,
          ),
        ),

        // Second message, in the login case it will be
        // Login to Continue
        Text(
          message2,
          style: const CustomTextStyle(),
        ),
      ],
    );
  }
}
