import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/widgets/others/screen_ratio.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      body:  ScreenRatio(
        child:  Center(
          child: CircularProgressIndicator(
            color: blueColor,
          ),
        ),
      ),
    );
  }
}
