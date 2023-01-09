
import 'package:bhatti_pos/shared/string_extension.dart';

class Order {
  String? orderNo;
  String? customerFirstName;
  String? createDate;
  double? netAmount;
  String? area;

  Order({
    this.orderNo,
    this.customerFirstName,
    this.createDate,
    this.netAmount,
    this.area,
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    customerFirstName = json['CustomerFirstName'];
    customerFirstName = customerFirstName!.capitalizeInitials();
    createDate = json['CreateDate'];
    
    netAmount = double.parse(json['NetAmount'].toStringAsFixed(5));
    area = json['CustomerAddress']!;
    area = area!.capitalizeInitials();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['OrderNo'] = orderNo;
    data['CustomerFirstName'] = customerFirstName;
    data['CreateDate'] = createDate;
    data['NetAmount'] = netAmount;
    return data;
  }
}
