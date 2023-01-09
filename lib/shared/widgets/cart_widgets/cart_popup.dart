import 'package:bhatti_pos/services/models/cart_product.dart';
import 'package:bhatti_pos/services/models/product.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:bhatti_pos/shared/widgets/others/custom_button.dart';
import 'package:bhatti_pos/shared/widgets/cart_widgets/quantity_adder.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

addToCart(BuildContext context, Product data, String customerName) {
  final cart = Provider.of<CartProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Row(
        children: [
          const Text(
            "Total quantity Available is",
            style: TextStyle400FW12FS(
              textColor: greyTextColor,
            ),
          ),
          const Space05h(),
          Text(
            "${data.currentStock!.round()}",
            style: const TextStyle400FW12FS(
              weight: FontWeight.w600,
              textColor: blueColor,
            ),
          ),
        ],
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Enter Quantity",
            style: CustomTextStyle(
              textColor: blueColor,
              size: 14,
            ),
            textAlign: TextAlign.left,
          ),
          const Space05v(),
          Quantity(
            quantity: 0,
            currentStock: data.currentStock!,
            size: MediaQuery.of(context).size.width,
          ),
        ],
      ),
      // Add to Cart Button
      content: CustomElevatedButton(
        onTap: () {
          if (ProductList.quantity > data.currentStock! ||
              ProductList.quantity == 0) {
            showToast("Invalid Quantity", Colors.white);
          } else {
            showToast("Successfully added", Colors.white);
            Navigator.of(context).pop(true);
            // double price = data.unitPrice! * ProductList.quantity - data.discount! * ProductList.quantity;
            double price = calculatePrice(data);
            DateTime dateTime = DateTime.now();
            price = double.parse(price.toStringAsFixed(3));
            CartProduct cartProduct = CartProduct(
              customerName: customerName,
              productId: data.productID!,
              productName: data.productName!,
              categoryId: data.categoryID!,
              categoryName: data.categoryName!,
              quantity: ProductList.quantity,
              totalPrice: price,
              timeStamp: dateTime.millisecondsSinceEpoch,
              unitPrice: data.unitPrice!,
              currentStock: data.currentStock!,
              discount: data.discount!,
            );
            cart.addCart(cartProduct);
            cart.incrementCount();
          }
        },
        color: blueColor,
        text: "Add to cart",
      ),
    ),
  );
}

updateCart(BuildContext context, CartProduct product) {
  final cart = Provider.of<CartProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Row(
        children: [
          const Text(
            "Total quantity Available is",
            style: TextStyle400FW12FS(
              textColor: greyTextColor,
            ),
          ),
          const Space05h(),
          Text(
            "${product.currentStock}",
            style: const TextStyle400FW12FS(
              weight: FontWeight.w600,
              textColor: blueColor,
            ),
          ),
        ],
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Enter Quantity",
            style: CustomTextStyle(
              textColor: blueColor,
              size: 14,
            ),
            textAlign: TextAlign.left,
          ),
          const Space05v(),
          Quantity(
            quantity: product.quantity,
            currentStock: product.currentStock,
            size: MediaQuery.of(context).size.width,
          ),
        ],
      ),
      // Add to Cart Button
      content: CustomElevatedButton(
        onTap: () {
          if (kDebugMode) print("updated quantity is ${ProductList.quantity}");
          if (ProductList.quantity > product.currentStock) {
            showToast("Invalid Quantity", Colors.white);
          } else if (ProductList.quantity == 0) {
            showToast("Quantity must be at least one", Colors.white);
          } else {
            showToast("Successfully Updated", Colors.white);
            Navigator.of(context).pop(true);
            double price = calculatePrice(product); 
            int dateTime = DateTime.now().millisecondsSinceEpoch;
            price = double.parse(price.toStringAsFixed(3));
            cart.updateCartData(
                price, ProductList.quantity, dateTime, product.productId);
          }
        },
        color: blueColor,
        text: "Update cart",
      ),
    ),
  );
}

double calculatePrice(product){
  return (product.unitPrice - product.discount) * ProductList.quantity;
}
