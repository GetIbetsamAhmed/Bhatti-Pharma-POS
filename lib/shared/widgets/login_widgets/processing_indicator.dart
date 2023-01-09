import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/others/custom_button.dart';
import 'package:flutter/material.dart';

class LoginWidgets {
  static processingIndicator(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: blueColor,
        ),
      ),
    );
  }

  static closeProcessingIndicator(BuildContext context) {
    Navigator.pop(context);
  }

  static unsuccessfull(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Sorry!",
              style: CustomTextStyle(
                textColor: greyTextColor,
                size: 30,
                weight: FontWeight.w600,
              ),
            ),
            const Space10v(),
            const Text(
              "Wrong email or password",
              style: CustomTextStyle(
                textColor: greyTextColor,
                size: 14,
              ),
            ),
            const Space20v(),
            CustomElevatedButton(
              onTap: () {
                Navigator.pop(context);
              },
              color: blueColor,
              text: "Ok",
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  static successfull(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: blueColor,
              ),
              child: const Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
            const Space25v(),
            const Text(
              "Successfully Loggedin",
              style: TextStyle600FW16FS(textColor: blueColor),
            ),
          ],
        ),
      ),
    );
  }
}
