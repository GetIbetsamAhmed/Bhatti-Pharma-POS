import 'package:bhatti_pos/services/models/products/cart_product.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/shared/widgets/cart_widgets/cart_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CartProductTile extends StatefulWidget {
  final CartProduct product;
  final bool isEditingOrder;
  final TextEditingController controller;
  const CartProductTile(
      {super.key,
      required this.product,
      required this.controller,
      this.isEditingOrder = false});

  @override
  State<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  @override
  Widget build(BuildContext context) {
    // DateTime dateTime =
    //     DateTime.fromMillisecondsSinceEpoch(widget.product.timeStamp);

    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              // Delete from cart
              SlidableAction(
                onPressed: (context) {
                  final cart =
                      Provider.of<CartProvider>(context, listen: false);
                  if (widget.isEditingOrder && cart.getAllCarts.length == 1) {
                    showToast("Cannot clear order", Colors.white);
                  } else {
                    cart.removeCart(widget.product);
                    cart.decrementCount();
                  }

                  if (cart.getAllCarts.isEmpty) {
                    Navigator.pop(context);
                    cart.setTotalPrice(0.0);
                  }
                  var provider = context.read<CartProvider>();
                  if (provider.getFilteredCarts.isEmpty) {
                    widget.controller.clear();
                    provider.clearCartFilters();
                  }
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
              ),
            ],
          ),
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              // Edit Cart
              SlidableAction(
                onPressed: (context) {
                  // ProductList.quantity =
                  //     int.parse(widget.product.quantity.toString());
                  // if (kDebugMode) print(widget.product.quantity);
                  updateCart(context, widget.product, widget.isEditingOrder);
                },
                icon: Icons.edit,
                backgroundColor: blueColor,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            // margin: const EdgeInsets.only(bottom: 10, left: 05, right: 05),
            decoration: BoxDecoration(
              borderRadius: borderRadius05,
              color: bgColor,
              border: border,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Space05v(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: Text(
                        widget.product.productName[0],
                        style: const CustomTextStyle(
                          textColor: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Space05h(),
                    Expanded(
                      child: Text(
                        widget.product.productName,
                        style: const TextStyle600FW16FS(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Space05v(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _valueContainer(
                      context,
                      "Units Ordered",
                      regulateNumber(
                        double.parse(
                          widget.product.quantity.toString(),
                        ),
                      ),
                    ),
                    _verticalDivider(context),
                    _valueContainer(
                      context,
                      "Unit Price (PKR)",
                      regulateNumber(
                        double.parse(
                          widget.product.unitPrice.toString(),
                        ),
                      ),
                    ),
                    _verticalDivider(context),
                    _valueContainer(
                      context,
                      "Discount per unit",
                      widget.isEditingOrder
                          ? "${widget.product.discount}%"
                          : "${(widget.product.discount * 100 / widget.product.unitPrice).toStringAsFixed(2)}%",
                    ),
                    _verticalDivider(context),
                    _valueContainer(
                      context,
                      "Payable Amount",
                      regulateNumber(
                        double.parse(
                          widget.product.totalPrice.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.product.dateTime,
                    style: const TextStyle400FW12FS(
                      textColor: greyTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // const Space10v(),
      ],
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 44 * MediaQuery.of(context).textScaleFactor,
      color: greyTextColor.withOpacity(.15),
    );
  }

  Widget _valueContainer(BuildContext context, String label, String value) {
    double widthRatio = 0.2;

    return SizedBox(
      // color: Colors.amber,
      // height: 50,
      width: MediaQuery.of(context).size.width * widthRatio,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(height: 02),
          Text(
            label,
            style: const CustomTextStyle(size: 11, textColor: greyTextColor),
            textAlign: TextAlign.center,
          ),
          const Space05v(),
          Text(
            value,
            style: const CustomTextStyle(
              weight: FontWeight.w700,
              size: 12,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
