// ignore_for_file: unused_field, prefer_final_fields

import 'package:bhatti_pos/services/models/products/cart_product.dart';
import 'package:bhatti_pos/services/models/category.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/models/daily_report_data.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/models/order_details.dart';
import 'package:bhatti_pos/services/models/products/product.dart';
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
  double _currentSalesAmount = 0.0;

  setCurrentSalesAmount(double amount) {
    _currentSalesAmount = amount;
    notifyListeners();
  }

  double get currentSalesAmount => _currentSalesAmount;

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

  void initializeCartListWithProductsToBeEditted() {
    // _cartList = _listOfProducts;
    // initialize cart list the list of all products that are to be editted.
    notifyListeners();
  }

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

  void updateCartDataWithProductName(
    double price,
    double quantity,
    // String dateTime,
    String productName,
  ) {
    double previousPrice = 0.0;
    for (CartProduct product in _cartList) {
      if (product.productName.compareTo(productName) == 0) {
        previousPrice = product.totalPrice;
        product.totalPrice = price;
        product.quantity = quantity;
        // product.dateTime = dateTime;
        break;
      }
    }
    // updating the price
    _totalPrice -= previousPrice;
    _totalPrice += price;
    notifyListeners();
  }

  void updateCartData(
    double price,
    double quantity,
    String dateTime,
    int productId,
  ) {
    double previousPrice = 0.0;
    for (CartProduct product in _cartList) {
      if (product.productId == productId) {
        previousPrice = product.totalPrice;
        product.totalPrice = price;
        product.quantity = quantity;
        product.dateTime = dateTime;
        break;
      }
    }
    // updating the price
    _totalPrice -= previousPrice;
    _totalPrice += price;
    notifyListeners();
  }

  int currentTagId = 0;

  filter(Categories tag, bool showTaost, {bool isOrderFilter = false}) {
    _currentTag = tag.id!;
    currentTagId = tag.id!;
    if (isOrderFilter == false) {
      if (tag.id != 0) {
        _allProductsForPOS = ProductList.allProducts
            .where((element) => element.categoryName!
                .toLowerCase()
                .contains(tag.name!.toLowerCase()))
            .toList();
      } else {
        _allProductsForPOS = ProductList.allProducts;
      }
      if (showTaost) {
        showToast(
          "Filtered by ${tag.name}, total Items ${_allProductsForPOS.length}",
          Colors.white,
        );
      }
    } else {
      if (!tag.name!.contains("All")) {
        _allOrders = OrderList.allOrders
            .where((element) => element.orderStatus!.contains(tag.name!))
            .toList();
      } else {
        _allOrders = OrderList.allOrders;
      }
      if (showTaost) {
        showToast(
          "Filtered by ${tag.name}, total Items ${_allOrders.length}",
          Colors.white,
        );
      }
    }
    notifyListeners();

    // return filteredData;
  }

  filterbyNumber(int id) {
    if (id != 0) {
      _allProductsForPOS = ProductList.allProducts
          .where((element) => element.categoryID == id)
          .toList();
    } else {
      _allProductsForPOS = ProductList.allProducts;
    }
    notifyListeners();
  }

  filterPOSProductsByString(String data) {
    bool valid = false;
    try {
      double.parse(data);
      valid = true;
    } catch (e) {
      valid = false;
    }

    Categories currentTag = CategoryList.categories[getCurrentTagIndex()];
    filter(currentTag, false);

    if (!valid) {
      _allProductsForPOS = _allProductsForPOS
          .where(
            (element) =>
                // element.categoryID == currentTagId &&
                (element.categoryName!
                        .toLowerCase()
                        .contains(data.toLowerCase()) ||
                    element.productName!
                        .toLowerCase()
                        .contains(data.toLowerCase())),
          )
          .toList();
    } else {
      _allProductsForPOS = _allProductsForPOS
          .where((element) =>
              // element.categoryID == currentTagId &&
              element.unitPrice! <= double.parse(data))
          .toList();
    }

    notifyListeners();
  }

  clearPOSProductFilters({bool fromPOSCustomers = false}) {
    if (fromPOSCustomers) {
      _allProductsForPOS = ProductList.allProducts;
      notifyListeners();
    } else {
      Categories currentTag = CategoryList.categories[getCurrentTagIndex()];
      filter(currentTag, false);
    }
  }

  filterProductsByString(String data) {
    bool valid = false;

    try {
      double.parse(data);
      valid = true;
    } catch (e) {
      valid = false;
    }

    if (!valid) {
      _allProductsForProduct = ProductList.allProducts
          .where(
            (element) =>
                element.categoryName!
                    .toLowerCase()
                    .contains(data.toLowerCase()) ||
                element.productName!
                    .toLowerCase()
                    .contains(data.toLowerCase()) ||
                element.categoryName!
                    .toLowerCase()
                    .contains(data.toLowerCase()),
          )
          .toList();
    } else {
      _allProductsForProduct = ProductList.allProducts
          .where((element) => element.unitPrice! <= double.parse(data))
          .toList();
    }

    notifyListeners();
  }

  clearProductFilters() {
    _allProductsForProduct = ProductList.allProducts;
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
          .where((element) =>
              element.productName.toLowerCase().contains(val) ||
              element.categoryName.toLowerCase().contains(val))
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

  int getCurrentTagIndex() {
    for (int i = 0; i < CategoryList.categories.length; i++) {
      if (CategoryList.categories[i].id! == currentTagId) {
        return i;
      }
    }
    return -1;
  }

  void searchOrderByData(String data) {
    data = data.toLowerCase();
    Categories currentTag = CategoryList.categories[getCurrentTagIndex()];
    filter(currentTag, false, isOrderFilter: true);

    _allOrders = _allOrders
        .where((element) =>
            element.customerFirstName!.toLowerCase().contains(data) ||
            element.orderNo!.contains(data) ||
            element.area!.toLowerCase().contains(data))
        .toList();

    notifyListeners();
  }

  void clearOrderFilter() {
    if (kDebugMode) print(currentTagId);

    Categories currentTag = CategoryList.categories[getCurrentTagIndex()];
    filter(currentTag, false, isOrderFilter: true);
    // notifyListeners();
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
