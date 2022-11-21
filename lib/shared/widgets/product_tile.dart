import 'package:bhatti_pos/services/models/product.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
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
        
        Positioned(
          bottom: 20,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 03, horizontal: 10),
            decoration: BoxDecoration(
            color: product.currentStock == 0
                ? lightRed
                : lightGreen, // gba(32, 229, 0, 0.05)
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              product.currentStock == 0? "Out of Stock": "Available",
              style: TextStyle400FW12FS(
                textColor: product.currentStock == 0
                    ? darkRed
                    : darkGreen,
              ),
            ),
          ),
        ),
        Column(
          children: [
            // const Space10v(),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(01),
                color: bgColor,
                border: border,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Space05v(),
                      Text(
                        product.productID!,
                        style: const TextStyle400FW12FS(),
                      ),
                      const Space05v(),
                      Text(
                        product.productName!,
                        style: const TextStyle600FW16FS(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Space05v(),
                      Text(product.unitPrice!, style: const TextStyle600FW16FS()),
                      const Space05v(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 03, horizontal: 05),
                            decoration: BoxDecoration(
                        color: product.paymentMedium!.compareTo("By Card") == 0
                            ? const Color(0xff007EE5).withOpacity(0.05)
                            : const Color(0xff20E500).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        child: Text(
                          product.paymentMedium.toString(),
                          style: TextStyle400FW10FS(
                            textColor:
                                product.paymentMedium?.compareTo("By Card") == 0
                                    ? blueColor
                                    : const Color(
                                        0xff20E500,
                                      ),
                          ),
                        ),
                      ),
                      const Space10v(),
                      Text(
                        "${product.bookingTime!} ${product.bookingDate!}",
                        style: const TextStyle400FW12FS(textColor: greyTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
