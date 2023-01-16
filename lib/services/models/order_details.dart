import 'package:flutter/foundation.dart';

class OrderDetails {
  String? orderno;
  String? productName;
  double? quantity;
  double? unitPrice;
  double? discount;
  double? amount;
  double? totalAmount;
  double? payableAmount;
  double? percentageDiscount;

  OrderDetails({
    this.orderno,
    this.productName,
    this.quantity,
    this.unitPrice,
    this.discount,
    this.amount,
    this.totalAmount,
    this.payableAmount,
    this.percentageDiscount,
  });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderno = json['Orderno'];
    productName = json['ProductName'];
    quantity = json['Quantity'];
    unitPrice = json['UnitPrice'];
    percentageDiscount =
        json['Discount'] == null ? 0.0 : double.parse("${json['Discount']}");
    discount = double.parse(
        ((percentageDiscount! / 100) * unitPrice!).toStringAsFixed(5));
    amount = json['Amount'];
    totalAmount = json['TotalAmount'];
    payableAmount =
        double.parse(((unitPrice! - discount!) * quantity!).toStringAsFixed(5));
    if (kDebugMode) print(payableAmount);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Orderno'] = orderno;
    data['ProductName'] = productName;
    data['Quantity'] = quantity;
    data['UnitPrice'] = unitPrice;
    data['Discount'] = discount;
    data['Amount'] = amount;
    data['TotalAmount'] = totalAmount;
    return data;
  }
}
