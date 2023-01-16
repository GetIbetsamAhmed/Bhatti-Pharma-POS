// ignore_for_file: file_names
class CartProduct{
  final String customerName;
  final String productName;
  // final int categoryId;
  final String categoryName;
  final int productId;
  double quantity;
  double totalPrice;
  String dateTime;
  final double unitPrice;
  final double currentStock;
  final double discount;

  CartProduct({
    required this.customerName,
    required this.productId,
    required this.productName,
    // required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.totalPrice,
    required this.dateTime,
    required this.unitPrice,
    required this.currentStock,
    required this.discount,
  });

  
}
