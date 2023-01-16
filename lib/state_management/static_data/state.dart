// import 'package:bhatti_pos/services/models/cart_product.dart';
import 'package:bhatti_pos/services/models/area_wise_report_data.dart';
import 'package:bhatti_pos/services/models/category.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/models/daily_report_data.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/models/order_details.dart';
import 'package:bhatti_pos/services/models/products/product.dart';
import 'package:bhatti_pos/services/models/sales_report_data.dart';

class ProductList {
  static List<Product> allProducts = [];
  static int quantity = 0;
  // static List<CartProduct> cartItemList = [];
}

class CategoryList {
  static List<Categories> categories = [];
  
}

class CustomerList{
  static List<Customer> customers = [];
}

class SupplierList{
  static List<Customer> suppliers = [];
}

class UserData{
  static String? userName;
}

class ReportList{
  static List<SalesReportData> salesReportData = [];
  static List<DailyReportData> dailyReports = [];
  static List<AreaWiseReportData> areaWiseReports = [];
}

class OrderList{
  static List<OrderDetails> orderDetails = [];
  static List<Order> allOrders = [];
}