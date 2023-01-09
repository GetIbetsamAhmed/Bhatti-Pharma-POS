import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String message, Color textColor) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT ,
    textColor: textColor,
    backgroundColor: Colors.black87,
  );
}
