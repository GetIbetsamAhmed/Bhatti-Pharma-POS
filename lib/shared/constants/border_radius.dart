import 'package:flutter/material.dart';

BorderRadius borderRadius03 = BorderRadius.circular(03);
BorderRadius borderRadius05 = BorderRadius.circular(05);
BorderRadius borderRadius01 = BorderRadius.circular(01);
BorderRadius borderRadius100 = BorderRadius.circular(100);
BorderRadius borderRadius05Top = const BorderRadius.only(
    topLeft: Radius.circular(05), topRight: Radius.circular(05));
BorderRadius borderRadiusTopOnly(double radius) {
  return BorderRadius.only(
      topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
}
