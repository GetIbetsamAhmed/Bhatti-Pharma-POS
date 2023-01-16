import 'package:bhatti_pos/shared/string_extension.dart';

class AreaWiseReportData{
  String? customerAddress;
  int? amount;


  AreaWiseReportData.fromJson(Map<String, dynamic> json){
    customerAddress = json['CustomerAddress'];
    customerAddress = customerAddress!.capitalizeInitials();
    amount = json['Amount'];
    
  }
}