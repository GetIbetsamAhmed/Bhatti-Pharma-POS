class Product {
  String? productID;
  String? productName;
  double? currentStock;
  String? unitPrice;
  String? paymentMedium;
  String? bookingDate;
  String? bookingTime;

  Product({
    this.productID,
    this.productName,
    this.currentStock,
    this.unitPrice,
    this.paymentMedium,
    this.bookingDate,
    this.bookingTime,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID'];
    productName = json['ProductName'];
    currentStock = json['CurrentStock'];
    unitPrice = json['UnitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ProductID'] = productID;
    data['ProductName'] = productName;
    data['CurrentStock'] = currentStock;
    data['UnitPrice'] = unitPrice;
    return data;
  }

  @override
  String toString() {
    return "$productID, $productName, $currentStock, $unitPrice";
    // return "";
  }
}
