class Product {
  int? productID;
  String? productName;
  double? currentStock;
  int? categoryID;
  double? unitPrice;
  String? categoryName;
  double? percentageDiscount;
  double? discount;

  Product({
    this.productID,
    this.productName,
    this.currentStock,
    this.unitPrice,
    this.categoryName,
    this.categoryID,
    this.percentageDiscount,
    this.discount,
  });

  Product.fromJson(Map<String, dynamic> json, int? reference) {
    categoryID = json['CategoryID'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    currentStock = json['CurrentStock'];
    unitPrice = json['UnitPrice'];
    categoryName = json['CategoryName'];
    percentageDiscount = double.parse("${json['Discount']}");
    discount = double.parse(
        (percentageDiscount! / 100 * unitPrice!).toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ProductID'] = productID;
    data['ProductName'] = productName;
    data['CurrentStock'] = currentStock;
    data['UnitPrice'] = unitPrice;
    data['CategoryID'] = categoryID;
    data['CategoryName'] = categoryName;
    data['Discount'] = discount;
    return data;
  }

  void updateStock(quantity) {
    // if (currentStock != null) {
      currentStock = currentStock! - quantity;
    // }
  }

  @override
  String toString() {
    return "$productID, $productName, $currentStock, $unitPrice";
    // return "";
  }
}
