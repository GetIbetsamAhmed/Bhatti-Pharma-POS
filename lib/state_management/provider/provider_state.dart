// ignore_for_file: unused_field, prefer_final_fields

import 'package:bhatti_pos/services/models/cart_product.dart';
import 'package:bhatti_pos/services/models/category.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/models/daily_report_data.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/models/order_details.dart';
import 'package:bhatti_pos/services/models/product.dart';
import 'package:bhatti_pos/services/models/sales_report_data.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  int _cartItemCount = 0;
  double _totalPrice = 0.0;
  List<CartProduct> _cartList = [];
  List<CartProduct> _filteredCartList = [];
  List<Product> _allProductsForPOS = ProductList.allProducts;
  List<Product> _allProductsForProduct = ProductList.allProducts;
  List<Customer> _allCustomers = CustomerList.customers;
  List<Order> _allOrders = OrderList.allOrders;
  List<Categories> _allCategories = CategoryList.categories;
  int _currentTag = 0;
  List<OrderDetails> _allOrderDetails = OrderList.orderDetails;
  List<DailyReportData> _allDailyReports = ReportList.dailyReports;
  List<SalesReportData> _allProductSalesReports = ReportList.salesReportData;

  // Sales Reports
  List<SalesReportData> get getAllProductSalesReports =>
      _allProductSalesReports;

  clearProductSalesReportFilters() {
    _allProductSalesReports = ReportList.salesReportData;
    notifyListeners();
  }

  filterProductSalesReports(String data) {
    double amount = 0.0;
    bool isParsed = false;
    try {
      amount = double.parse(data);
      isParsed = true;
    } catch (e) {
      isParsed = false;
    }
    // User wanna searched as price
    if (isParsed) {
      _allProductSalesReports = ReportList.salesReportData
          .where((report) => report.netAmount! <= amount)
          .toList();
    }
    // User wanna search through the name
    else {
      data = data.toLowerCase();
      _allProductSalesReports = ReportList.salesReportData
          .where((report) => report.productName!.toLowerCase().contains(data))
          .toList();
    }
    notifyListeners();
  }

  // Daily Reports
  List<DailyReportData> get getDailyReports => _allDailyReports;

  filterDailyReports(String val) {
    val = val.toLowerCase();
    _allDailyReports = ReportList.dailyReports
        .where((report) =>
            report.orderNo!.toLowerCase().contains(val) ||
            report.areaName!.toLowerCase().contains(val) ||
            report.partyName!.toLowerCase().contains(val))
        .toList();

    notifyListeners();
  }

  clearDailyReportsFilter() {
    _allDailyReports = ReportList.dailyReports;
    notifyListeners();
  }

  // Cart Item Count Value
  int get getCount => _cartItemCount;

  void incrementCount() {
    _cartItemCount++;
    notifyListeners();
  }

  // Order Details
  List<OrderDetails> get orderDetails => _allOrderDetails;
  filterOrderDetails(String val) {
    // element.customerName!.toLowerCase().contains(name.toLowerCase())
    double amount = 0.0;
    bool isParsedSuccessfully = false;
    try {
      amount = double.parse(val);
      isParsedSuccessfully = true;
    } catch (e) {
      isParsedSuccessfully = false;
    }
    if (isParsedSuccessfully) {
      _allOrderDetails = OrderList.orderDetails
          .where((element) => element.payableAmount! <= amount)
          .toList();
    } else {
      _allOrderDetails = OrderList.orderDetails
          .where((element) =>
              element.productName!.toLowerCase().contains(val.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  clearOrderDetailSFilter() {
    _allOrderDetails = OrderList.orderDetails;
    notifyListeners();
  }

  void decrementCount() {
    _cartItemCount--;
    notifyListeners();
  }

  void setCount(int count) {
    _cartItemCount = count;
    notifyListeners();
  }

  // Cart List

  void setCartLists(List<CartProduct> list) {
    _cartList = list;
    notifyListeners();
  }

  void addCart(CartProduct product) {
    _cartList.add(product);
    _totalPrice += product.totalPrice;
    notifyListeners();
  }

  void removeCart(CartProduct product) {
    _cartList.remove(product);
    if (_filteredCartList.contains(product)) {
      _filteredCartList.remove(product);
    }
    _totalPrice -= product.totalPrice;
    notifyListeners();
  }

  void clearCarts() {
    _cartList.clear();
    _totalPrice = 0.0;
    setCount(0);
    notifyListeners();
  }

  void updateCartData(
    double price,
    int quantity,
    int timeStamp,
    int productId,
  ) {
    double previousPrice = 0.0;
    for (CartProduct product in _cartList) {
      if (product.productId == productId) {
        previousPrice = product.totalPrice;
        product.totalPrice = price;
        product.quantity = quantity;
        product.timeStamp = timeStamp;
        break;
      }
    }
    // updating the price
    _totalPrice -= previousPrice;
    _totalPrice += price;
    notifyListeners();
  }

  int currentTagId = 0;

  filter(Categories tag) {
    if (tag.id != getTagValue) {
      setTagValue(tag.id!);
      currentTagId = tag.id!;
      if (tag.id != 0) {
        _allProductsForPOS = ProductList.allProducts
            .where((element) => element.categoryID == tag.id)
            .toList();
      } else {
        _allProductsForPOS = ProductList.allProducts;
      }
      notifyListeners();
      showToast(
          "Filtered by ${tag.name}, total Items ${_allProductsForPOS.length}",
          Colors.white);
    }
    // return filteredData;
  }

  filterProductbyNumber(int id) {
    if (id != 0) {
      _allProductsForPOS = ProductList.allProducts
          .where((element) => element.categoryID == id)
          .toList();
    } else {
      _allProductsForPOS = ProductList.allProducts;
    }
    notifyListeners();
  }

  filterProductsByString(String data, bool isPOS) {
    bool valid = false;
    List<Product> localList = [];
    try {
      double.parse(data);
      valid = true;
    } catch (e) {
      valid = false;
    }
    // _allProducts = ProductList.allProducts;
    if (currentTagId != 0) {
      if (!valid) {
        localList = ProductList.allProducts
            .where(
              (element) =>
                  element.categoryID == currentTagId &&
                  (element.categoryName!
                          .toLowerCase()
                          .contains(data.toLowerCase()) ||
                      element.productName!
                          .toLowerCase()
                          .contains(data.toLowerCase())),
            )
            .toList();
      } else {
        localList = ProductList.allProducts
            .where((element) =>
                element.categoryID == currentTagId &&
                element.unitPrice! <= double.parse(data))
            .toList();
      }
    } else {
      if (!valid) {
        localList = ProductList.allProducts
            .where(
              (element) => (element.categoryName!
                      .toLowerCase()
                      .contains(data.toLowerCase()) ||
                  element.productName!
                      .toLowerCase()
                      .contains(data.toLowerCase())),
            )
            .toList();
      } else {
        localList = ProductList.allProducts
            .where((element) => element.unitPrice! <= double.parse(data))
            .toList();
      }
    }
    if (isPOS) {
      _allProductsForPOS = localList;
    } else {
      _allProductsForProduct = localList;
    }
    notifyListeners();
  }

  clearProductFilters(bool isPOS) {
    if (isPOS) {
      if (kDebugMode) print("IT is pos");
      filterProductbyNumber(currentTagId);
    } else {
      _allProductsForProduct = ProductList.allProducts;
    }
    if (kDebugMode) {
      print(
          "POS Products count ${_allProductsForPOS.length} and ProductScreen Product Count ${_allProductsForProduct.length}");
    }
    notifyListeners();
  }

  List<CartProduct> get getAllCarts => _cartList;
  List<CartProduct> get getFilteredCarts => _filteredCartList;
  filterCarts(String val) {
    double amount = 0.0;
    bool isParsed = false;
    try {
      amount = double.parse(val);
      isParsed = true;
    } catch (e) {
      isParsed = false;
    }
    if (isParsed) {
      _filteredCartList =
          _cartList.where((element) => element.unitPrice <= amount).toList();
    } else {
      _filteredCartList = _cartList
          .where((element) => element.productName.toLowerCase().contains(val))
          .toList();
    }
    notifyListeners();
  }

  clearCartFilters() {
    _filteredCartList = _cartList;
    notifyListeners();
  }

  CartProduct getProductAtIndex(int index) {
    return _cartList[index];
  }

  List<CartProduct> get getAllCartProducts => _cartList;

  // Product List State Management
  // void setAllProducts(List<Product> products) {
  //   _allProducts = products;
  //   notifyListeners();
  // }

  // void setProduct(Product product) {
  //   _allProducts.add(product);
  //   // print(_allProducts.length);
  //   notifyListeners();
  // }

  List<Product> get getProductsForPOS => _allProductsForPOS;
  List<Product> get getProductsForProducts => _allProductsForProduct;

  // Customer List State Management
  void setAllCustomers(List<Customer> customers) {
    _allCustomers = customers;
    notifyListeners();
  }

  void resetCustomers() {
    _allCustomers = CustomerList.customers;
    // _allCustomers.sort();
    notifyListeners();
  }

  List<Customer> get getCustomers => _allCustomers;

  filterCustomerByName(String name) {
    _allCustomers = CustomerList.customers
        .where((element) =>
            element.customerName!.toLowerCase().contains(name.toLowerCase()) ||
            element.phone!.toLowerCase().contains(name.toLowerCase()) ||
            element.area!.toLowerCase().contains(name.toLowerCase()))
        .toList();
    notifyListeners();
  }

  clearCustomerFilter() {
    _allCustomers = CustomerList.customers;
    notifyListeners();
  }

  // OrderList State Management
  void setAllOrders(List<Order> orderList) {
    _allOrders = orderList;
  }

  List<Order> get getAllOrders => _allOrders;

  void searchOrderByData(String data) {
    data = data.toLowerCase();
    _allOrders = OrderList.allOrders
        .where((element) =>
                element.customerFirstName!.toLowerCase().contains(data) ||
                element.orderNo!.contains(data) ||
                element.area!.toLowerCase().contains(data)
            // element.createDate!.toLowerCase().contains(data.toLowerCase()),
            )
        .toList();

    notifyListeners();
  }

  void clearOrderFilter() {
    _allOrders = OrderList.allOrders;
    notifyListeners();
  }

  // Total Price
  double getTotalPrice() {
    return _totalPrice;
  }

  void setTotalPrice(double price) {
    _totalPrice = price;
    notifyListeners();
  }

  void updatePrice(double price) {
    if (_totalPrice < 0) {
      _totalPrice = 0.0;
    } else {
      _totalPrice = price;
    }
    notifyListeners();
  }

  // Tags State Management
  int get getTagValue => _currentTag;
  void setTagValue(int val) {
    _currentTag = val;
    notifyListeners();
  }
}
