import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.getCount != 0) {
            return Stack(
              children: [
                const Positioned(
                  bottom: 0,
                  child: Icon(
                    Icons.shopping_cart_sharp,
                    color: blueColor,
                  ),
                ),
                // if(CartStateManager().count != 0)

                Positioned(
                  top: 0,
                  right: 04,
                  child: Container(
                    // height: 15,
                    // width: 15,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 05, vertical: 02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        value.getCount.toString(),
                        style:
                            const TextStyle400FW10FS(textColor: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Icon(
              Icons.shopping_cart_sharp,
              color: greyTextColor,
            );
          }
        },
      ),
    );
  }
}
