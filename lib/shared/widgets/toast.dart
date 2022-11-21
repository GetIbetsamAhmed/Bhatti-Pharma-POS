import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String message, Color textColor) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    textColor: textColor,
    backgroundColor: blueColor,
  );
}
