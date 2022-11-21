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
      height: size,
      width: size,
      child: Image.asset(
        "assets/logo/logo500.png",
        fit: BoxFit.fill,
      ),
    );
  }
}
