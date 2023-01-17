import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';

String formatDateTime(String dateTime) {
  String date = formatDate(dateTime.split("T")[0]);
  String time = formatTime(dateTime.split("T")[1]);
  return "$date $time";
}

String formatDate(String date) {
  List<String> tempDate = date.split("-");
  return "${tempDate[2]}-${tempDate[1]}-${tempDate[0]}";
}

String formatTime(String time) {
  List<String> tempTime = time.split(".")[0].split(":");
  int hour = int.parse(tempTime[0]);

  if (hour == 0 || hour == 24) {
    tempTime[0] = "12";
    tempTime.add("AM");
  } else if (hour > 0 && hour < 12) {
    tempTime.add("AM");
  } else if (hour == 12) {
    tempTime.add("PM");
  } else {
    tempTime[0] = "${hour - 12}";
    tempTime.add("PM");
  }
  time = "";
  int i = 0;
  while (i < tempTime.length - 2) {
    time += tempTime[i++];
    time += ":";
  }
  return "$time${tempTime[tempTime.length - 2]} ${tempTime[tempTime.length - 1]}";
}

void closeKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

bool closeKeyboardOnScroll(val) {
  FocusManager.instance.primaryFocus?.unfocus();
  return true;
}

String regulateNumber(double num) {
  // String value = "";
  // if (num < 10000) {
  //   value = num.toString();
  // }
  // if (num >= 10000 && num < 10000000) {
  //   value = "${(num / 1000).toStringAsFixed(2)}K";
  // } else if (num >= 1000000) {
  //   value = "${(num / 1000000).toStringAsFixed(2)}M";
  // }
  // return value; 
  return num.toString();
}

bool validateEmail(String value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value.isNotEmpty && regex.hasMatch(value)) {
    return true;
  }
  return false;
}

void sortCustomerList() {
  CustomerList.customers.sort(
    (customer1, customer2) =>
        customer1.customerName!.compareTo(customer2.customerName!),
  );
}

showCountToastInApp(List data, String message){
  if(data.isEmpty){
    showToast("No ${message}s", Colors.white);
  } else if(data.length == 1){
    showToast("1 $message to display", Colors.white);
  } else {
    showToast("${data.length} ${message}s to diaplay", Colors.white);
  }
}