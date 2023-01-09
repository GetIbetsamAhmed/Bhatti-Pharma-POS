import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:flutter/material.dart';

pickDate(BuildContext context, String helpText) async {
  return await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1990),
    lastDate: DateTime(2100),
    helpText: helpText,
    builder: (context, child) => Theme(
      data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
        primary: blueColor,
        surface: Colors.white,
        // onSurface: blueColor,
      )),
      child: child!,
    ),
  );
}
