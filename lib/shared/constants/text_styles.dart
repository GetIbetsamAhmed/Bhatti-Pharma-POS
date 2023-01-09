// import 'dart:ui';

import 'package:flutter/material.dart';

class TextStyle400FW12FS extends TextStyle {
  final Color textColor;
  final FontWeight weight;
  const TextStyle400FW12FS({
    this.textColor = Colors.black,
    this.weight = FontWeight.w400,
  }) : super(
          fontSize: 12,
          fontWeight: weight,
          color: textColor,
          letterSpacing: 0.5,
        );
}

class TextStyle400FW10FS extends TextStyle {
  final Color textColor;
  const TextStyle400FW10FS({
    this.textColor = Colors.black,
  }) : super(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: textColor,
          letterSpacing: 0.5,
        );
}

class TextStyle600FW16FS extends TextStyle {
  final Color textColor;
  const TextStyle600FW16FS({
    this.textColor = Colors.black,
  }) : super(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        );
}

class CustomTextStyle extends TextStyle {
  final Color textColor;
  final FontWeight weight;
  final double size;
  const CustomTextStyle({
    this.textColor = Colors.black,
    this.weight = FontWeight.normal,
    this.size = 14,
  }) : super(
          fontSize: size,
          fontWeight: weight,
          color: textColor,
          letterSpacing: 0.5,
        );
}
