class GridData {
  // customer
  static GridIcons customer =
      GridIcons(imagePath: "assets/icons/customers.svg", text: "Customers");

  // supplier
  static GridIcons supplier =
      GridIcons(imagePath: "assets/icons/supplier.svg", text: "Suppliers");

  // products
  static GridIcons products =
      GridIcons(imagePath: "assets/icons/product.svg", text: "Products");

  // pos
  static GridIcons pos =
      GridIcons(imagePath: "assets/icons/pos.svg", text: "POS");

  // expense
  static GridIcons expense =
      GridIcons(imagePath: "assets/icons/expense.svg", text: "Expenses");

  // orders
  static GridIcons orders =
      GridIcons(imagePath: "assets/icons/order.svg", text: "All Orders");

  // reports
  static GridIcons reports =
      GridIcons(imagePath: "assets/icons/report.svg", text: "Reports");

  // settings
  static GridIcons settings =
      GridIcons(imagePath: "assets/icons/settings.svg", text: "Settings");

  // aboutUs
  static GridIcons aboutUs =
      GridIcons(imagePath: "assets/icons/customers.svg", text: "About Us");

  // logout
  static GridIcons logout =
      GridIcons(imagePath: "assets/icons/log-out.svg", text: "Log Out");
}

class GridIcons {
  final String? imagePath;
  final String? text;

  GridIcons({this.imagePath, this.text});
}
