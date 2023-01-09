import 'package:flutter/material.dart';

class ScreenRatio extends StatelessWidget {
  final Widget child;
  final bool enableTop;
  const ScreenRatio({
    super.key,
    this.enableTop = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: enableTop? 10: 0, left: 15, right: 15),
        child: child,
      ),
    );
  }
}
