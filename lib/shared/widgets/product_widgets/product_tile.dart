import 'package:bhatti_pos/services/models/products/product.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        //   bottom: 20,
        //   left: 10,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(vertical: 03, horizontal: 10),
        //     decoration: BoxDecoration(
        //     color: product.currentStock == 0
        //         ? lightRed
        //         : lightGreen, // gba(32, 229, 0, 0.05)
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: Text(
        //       product.currentStock == 0? "Out of Stock": "Available",
        //       style: TextStyle400FW12FS(
        //         textColor: product.currentStock == 0
        //             ? darkRed
        //             : darkGreen,
        //       ),
        //     ),
        //   ),
        // ),
        Column(
          children: [
            // const Space10v(),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10, left: 05, right: 05),
              decoration: BoxDecoration(
                borderRadius: borderRadius05,
                color: bgColor,
                border: border,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row of Product Id and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      showTextWithTwoColors(
                          "Product Id: ", product.productID!.toString()),
                      Text(
                        "PKR: ${product.unitPrice!}",
                        style: const TextStyle600FW16FS(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 03),
                  // Product Name
                  Text(
                    product.productName!,
                    style: const TextStyle600FW16FS(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 03),
                  // Available Units(Current Stock)
                  showTextWithTwoColors(
                      "Available Units: ", product.currentStock!.toString()),
                  const SizedBox(height: 03),
                  // percentage Discount
                  showTextWithTwoColors(
                      "Discount: ", "${product.percentageDiscount!}%"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  showTextWithTwoColors(String str1, String str2) {
    return Row(
      children: [
        Text(
          str1,
          style: const TextStyle400FW12FS(textColor: greyTextColor),
        ),
        Text(
          str2,
          style: const TextStyle400FW12FS(
            textColor: blueColor,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
