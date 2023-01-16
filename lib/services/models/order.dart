import 'package:bhatti_pos/shared/string_extension.dart';

class Order {
  String? orderNo;
  String? customerFirstName;
  String? createDate;
  double? netAmount;
  String? area;
  String? orderStatus;

  Order({
    this.orderNo,
    this.customerFirstName,
    this.createDate,
    this.netAmount,
    this.area,
    this.orderStatus,
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    customerFirstName = json['CustomerFirstName'];
    customerFirstName = customerFirstName!.capitalizeInitials();
    createDate = json['CreateDate'];
    netAmount = double.parse(json['NetAmount'].toStringAsFixed(2));
    area = json['CustomerAddress']!;
    area = area!.capitalizeInitials();
    orderStatus = json['OrderStatus'];
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
