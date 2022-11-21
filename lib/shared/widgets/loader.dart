import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:flutter/material.dart';

class Loader {
  static bool isLoaderOpen = false;
  showLoader(BuildContext context) {
    isLoaderOpen = true;
    return showDialog(
      context: context,
      builder: (_) {
        return const Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              color: blueColor,
              strokeWidth: 04,
            ),
          ),
        );
      },
    );
  }
  hideLoader(BuildContext context){
    isLoaderOpen = false;
    Navigator.of(context).pop();
  }
}
