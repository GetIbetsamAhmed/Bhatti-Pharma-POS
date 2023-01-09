// ignore_for_file: file_names
import 'dart:convert';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIClient {
  Map<String, String> headers = {
    "Content-type": "application/json",
  };

  final String _serviceHostAddress =
      "http://daniyalabid-001-site1.dtempurl.com/api/services/";

  // Get all products
  Future<dynamic> getAllProducts() async {
    var uri = Uri.parse("${_serviceHostAddress}GetAllProducts");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  // Get all categories to be used in the tags
  Future<dynamic> getAllCategories() async {
    var uri = Uri.parse("${_serviceHostAddress}GetCategory");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  // get all orders based on user name
  Future<dynamic> getAllOrders(String userName) async {
    var uri =
        Uri.parse("${_serviceHostAddress}GetAllOrders?username=$userName");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      if (kDebugMode) print("Tptal orders are ${res.length}");
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  // get the order details against the order number
  Future<dynamic> getOrderDetails(String orderNumber) async {
    var uri =
        Uri.parse("${_serviceHostAddress}GetOrderById?OrderNo=$orderNumber");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Invalid Order", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  // Get all order reports against the user name
  Future<dynamic> getDailyReports(String userName, String date) async {
    // print(date);
    var uri = Uri.parse(
        "${_serviceHostAddress}DailySaleReport?sdate=$date&storderno=&endorderno=&username=$userName");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  // Post Order
  Future<String> postOrder(Map<String, dynamic> data) async {
    String returnValue = "";
    var body = jsonEncode(data);
    var uri = Uri.parse("${_serviceHostAddress}createorder");
    var response = await http.post(uri, body: body, headers: headers);

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body).toString();
      showToast(res, Colors.white);
      returnValue = res;
    } else {
      showToast("Invalid Order", Colors.white);
    }
    return returnValue;
    // print(body);
    // await Future.delayed(const Duration(milliseconds: 2000));
  }

  // Get product vise order reports
  Future<dynamic> getProductReport(
      String userName, String startingDate, String endingDate) async {
    var uri = Uri.parse(
        "${_serviceHostAddress}ItemWiseSales?startdate=$startingDate-$endingDate&storderno=100018790&endorderno=100018797&username=$userName");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  Future<dynamic> getAreaWiseReport(String userName) async {
    var uri = Uri.parse("${_serviceHostAddress}SalesStats?username=$userName");
    var response = await http.get(uri);
// http://daniyalabid-001-site1.dtempurl.com/api/services/SalesStats?username=Azhar Shah
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  // User Login
  Future<dynamic> login(String userEmail, String password) async {
    var uri = Uri.parse(
        "${_serviceHostAddress}Login?Email=$userEmail&Password=$password");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      throw Exception("Status Code : ${response.statusCode}");
    }
  }

  // Create Customer
  Future<dynamic> createCustomer(
    String userName,
    String area,
    String phone,
    String customerName,
  ) async {
    var uri = Uri.parse("${_serviceHostAddress}CreateCustomer");
    var body = jsonEncode({
      "Area": area,
      "CustomerName": customerName,
      "Phone": phone,
      "UserName": userName,
    });
    var response = await http.post(uri, body: body, headers: headers);

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body).toString();
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      return null;
    }
  }

  // Editing Customer
  Future<dynamic> editCustomer(
    int id,
    String area,
    String customerName,
    String phone,
    String userName,
  ) async {
    var body = jsonEncode({
      "Id": id,
      "Area": area,
      "CustomerName": customerName,
      "Phone": phone,
      "UserName": userName
    });
    var uri = Uri.parse("${_serviceHostAddress}EditCustomer");
    var response = await http.post(uri, body: body, headers: headers);

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body).toString();
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      return null;
    }
  }

  // Delete Customer
  Future<dynamic> deleteCustomer(
    int id,
  ) async {
    var body = jsonEncode({});
    var uri = Uri.parse("${_serviceHostAddress}DeleteCustomers?id=$id");
    var response = await http.post(uri, body: body, headers: headers);

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body).toString();
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      return null;
    }
  }

  // get all customers based on the user name
  Future<dynamic> getAllCustomers(String userName) async {
    if (kDebugMode) print("Api Get All Customers Called");
    var uri =
        Uri.parse("${_serviceHostAddress}GetCustomers?username=$userName");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      return res;
    } else {
      showToast("Status Code : ${response.statusCode}", Colors.white);
      // throw Exception("Status Code : ${response.statusCode}");
    }
  }
}
