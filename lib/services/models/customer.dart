import 'package:bhatti_pos/shared/string_extension.dart';

class Customer {
  int? id;
  String? userName;
  String? customerName;
  String? area;
  String? phone;
  bool? status;
  String? createDate;
  String? bookingDay;

  Customer({
    this.id,
    this.userName,
    this.customerName,
    this.area,
    this.phone,
    this.status,
    this.createDate,
    this.bookingDay,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userName = json['UserName'];
    customerName = json['CustomerName'];
    customerName = customerName!.capitalizeInitials();
    area = json['Area'];
    area = area!.capitalizeInitials();
    phone = json['Phone'];
    status = json['Status'];
    createDate = json['CreateDate'];
    bookingDay = json['BookingDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = id;
    data['UserName'] = userName;
    data['CustomerName'] = customerName;
    data['Area'] = area;
    data['Phone'] = phone;
    data['Status'] = status;
    data['CreateDate'] = createDate;
    data['BookingDay'] = bookingDay;
    return data;
  }
}

