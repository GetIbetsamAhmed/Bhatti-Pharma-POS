import 'package:bhatti_pos/shared/widgets/others/screen_ratio.dart';
import 'package:flutter/material.dart';

class CustomInternetState extends StatelessWidget {
  const CustomInternetState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenRatio(
        child: Center(
          child: Text("No Internet"),
        ),
      ),
    );
  }
}
