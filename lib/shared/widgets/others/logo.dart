// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;
  final bool colored;
  const Logo({
    super.key,
    required this.size,
    this.colored = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colored ? Colors.amber : Colors.transparent,
      height: (size/3)*2,
      width: size,
      child: Image.asset(
        "assets/logo/logo500.png",
        fit: BoxFit.fill,
      ),
    );
  }
}

class LogoIcon extends StatelessWidget {
  final double height; 
  final double width;
  const LogoIcon({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.asset(
        "assets/logo/Icon.png",
        alignment: Alignment.topLeft,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
