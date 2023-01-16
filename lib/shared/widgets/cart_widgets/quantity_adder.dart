// ignore_for_file: prefer_final_fields

import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Quantity extends StatefulWidget {
  final int quantity;
  final double currentStock;
  final double size;
  final bool isEditingOrder;
  const Quantity({
    super.key,
    required this.currentStock,
    required this.quantity,
    required this.size,
    this.isEditingOrder = false,
  });

  @override
  State<Quantity> createState() => _QuantityState();
}

class _QuantityState extends State<Quantity> {
  TextEditingController? quantityController;

  @override
  void dispose() {
    super.dispose();
    quantityController!.dispose();
  }

  @override
  void initState() {
    quantityController = TextEditingController();
    ProductList.quantity = int.parse(widget.quantity.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    quantityController!.text = ProductList.quantity.toString();

    return Container(
      color: Colors.transparent,
      width: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Inrement Button
          ElevatedButton(
            onPressed: () {
              if (ProductList.quantity <= widget.currentStock) {
                // showToast("${ProductList.quantity++}", Colors.white);
                ProductList.quantity++;
                // ProductList.quantity += double.parse("Hafce00453dfg234fdksd".replaceAll(RegExp(r'[^0-9]'),''));
              } else {
                showToast("Limit exceeded", Colors.white);
              }
              setState(() {});
              if (kDebugMode) print(ProductList.quantity);
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              minimumSize: MaterialStateProperty.all(const Size(0, 0)),
              padding: MaterialStateProperty.all(
                const EdgeInsets.only(
                  left: 05,
                  right: 05,
                  top: 02,
                  bottom: 02,
                ),
              ),
            ),
            child: const Icon(Icons.add),
          ),
          const Space05h(),

          // Quantity
          SizedBox(
            width: 50,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                controller: quantityController!,
                validator: (value) {
                  if (kDebugMode) {
                    print("From Validor $value");
                    print("product quantity is ${ProductList.quantity}");
                  }
                    if (value!.isNotEmpty) {
                      ProductList.quantity = int.parse(value);
                      if (value[0] == "-" ||
                          int.parse(value) > widget.currentStock) {
                        return "Invalid";
                      }
                    }
                    if (value.isEmpty) {
                      // quantityController!.text = "0";
                      ProductList.quantity = 0;
                      return "Empty";
                    }
                  // } else {
                  //   if (value!.isNotEmpty) {
                  //     if (widget.currentStock <= 0) {
                  //       if (value[0] == '-') {
                  //         return "Invalid";
                  //       }
                  //       if (int.parse(value) <= ProductList.quantity) {
                  //         ProductList.quantity = int.parse(value);
                  //       } else {
                  //         return "Invalid";
                  //       }
                  //     } else {}
                  //   }
                  //   if (value.isEmpty) {
                  //     // quantityController!.text = "0";
                  //     // ProductList.quantity = 0;
                  //     return "Empty";
                  //   }
                  // }
                  // quantityController!.text = value;
                  return null;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const Space05h(),
          // Decrement Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (ProductList.quantity != 0.0) {
                  ProductList.quantity -= 1;
                } else {
                  showToast("Invalid operation", Colors.white);
                }
              });
              if (kDebugMode) print(ProductList.quantity);
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              minimumSize: MaterialStateProperty.all(const Size(0, 0)),
              padding: MaterialStateProperty.all(
                const EdgeInsets.only(
                  left: 05,
                  right: 05,
                  top: 02,
                  bottom: 02,
                ),
              ),
            ),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
