import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:flutter/material.dart';

final BoxBorder border = Border.all(
  width: 2,
  color: borderColor,
);

const BorderSide borderSide = BorderSide(
  color: borderColor,
  width: 1.5,
);

final BoxBorder blueBorder = Border.all(
  color: blueColor,
  width: 0.75,
);

final BoxBorder blueBorder05 = Border.all(
  color: blueColor.withOpacity(.05),
  width: 0.75,
);

final BoxBorder blueborder100 = Border.all(
  width: 2,
  color: blueColor,
);

BoxBorder customColorblueBorder(Color color) {
  return Border.all(
    width: 2,
    color: color,
  );
}
