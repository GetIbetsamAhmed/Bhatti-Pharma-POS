import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/widgets/logo.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              const Logo(size: 150),
              Positioned(
                top: height - 30,
                child: Text(
                  message1,
                  style: const TextStyle(
                    color: blueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    // height: 29.05,
                  ),
                ),
              ),
            ],
          ),
        ),
       
       Center(
          child: Text(
            message2,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
