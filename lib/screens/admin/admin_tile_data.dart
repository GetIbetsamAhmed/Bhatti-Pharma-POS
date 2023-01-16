class GridData {
  static List<GridIcons> allGridTabs = [
    // customer
    GridIcons(
      imagePath: "assets/icons/customers.svg",
      text: "Customers",
    ),

    // products
    GridIcons(
      imagePath: "assets/icons/product.svg",
      text: "Products",
    ),

    // pos
    GridIcons(
      imagePath: "assets/icons/pos.svg",
      text: "POS",
    ),

    // orders
    GridIcons(
      imagePath: "assets/icons/order.svg",
      text: "All Orders",
    ),

    // reports
    GridIcons(
      imagePath: "assets/icons/report.svg",
      text: "Reports",
    ),

    // logout
    GridIcons(
      imagePath: "assets/icons/log-out.svg",
      text: "Log Out",
    ),
  ];
}

class GridIcons {
  final String? imagePath;
  final String? text;
  GridIcons({
    this.imagePath,
    this.text,
  });
}
