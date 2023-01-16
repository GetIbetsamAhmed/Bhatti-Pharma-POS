// ignore_for_file: iterable_contains_unrelated_type

import 'package:bhatti_pos/services/models/products/cart_product.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/models/products/product.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/cart_widgets/cart_popup.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
// import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class POSTile extends StatefulWidget {
  final Product data;
  final Customer customer;
  final int index;
  const POSTile({
    super.key,
    required this.data,
    required this.customer,
    required this.index,
  });

  @override
  State<POSTile> createState() => _POSTileState();
}

class _POSTileState extends State<POSTile> {
  String temporaryImage =
      "https://tse4.mm.bing.net/th?id=OIP.T0ge74IF2d6xbC0TWsqBpAHaHa&pid=Api&P=0";

  bool productIdInList(int id) {
    final cartList = Provider.of<CartProvider>(context, listen: false);
    for (CartProduct item in cartList.getAllCarts) {
      if (item.productId == id) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print(
        //     "index ${widget.index} and element in product list ${ProductList.allProducts[widget.index].productName}");

        // if(kDebugMode) print(widget.data.productID!);
        bool inList = productIdInList(widget.data.productID!);

        // Case 1
        // The product to be added in the cart has no stock to be sold...
        if (widget.data.currentStock == 0) {
          showToast("This item is out of stock", Colors.white);
        }
        // Case 2
        // If the product is already added to the cart, then it must not be added again.
        // it can only be modified or removed from the cart screen
        else if (inList) {
          showToast("Already in list", Colors.white);
        }
        // Case 3
        // If the product has the stock, and is not already in list
        // add it to the cart
        else {
          addToCart(context, widget.data, widget.customer.customerName!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: blueBorder05,
          color: blueColor.withOpacity(0.02),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circle containing first letter or product name
                  CircleAvatar(
                    radius: 30,
                    child: Center(
                      child: Text(
                        widget.data.productName![0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const Space05v(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 03,
                      top: 03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Product Name
                        Text(
                          widget.data.productName!,
                          style: const CustomTextStyle(
                            textColor: greyTextColor,
                            size: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Price
                        const SizedBox(height: 02),
                        Text(
                          "PKR. ${regulateNumber(widget.data.unitPrice!)}",
                          style: CustomTextStyle(
                            size: 10.5,
                            weight: FontWeight.w600,
                            textColor: blueColor.withOpacity(0.85),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Discount Widget
                        Text(
                          widget.data.percentageDiscount! > 0
                              ? "Discount: ${widget.data.percentageDiscount!.toStringAsFixed(2)}%"
                              : "No discount",
                          style: const CustomTextStyle(
                            size: 10,
                            weight: FontWeight.normal,
                            textColor: greyTextColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
