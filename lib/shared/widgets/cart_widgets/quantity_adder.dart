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
  const Quantity({
    super.key,
    required this.currentStock,
    required this.quantity,
    required this.size,
  });

  @override
  State<Quantity> createState() => _QuantityState();
}

class _QuantityState extends State<Quantity> {
  TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
  }

  @override
  void initState() {
    ProductList.quantity = widget.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    quantityController.text = ProductList.quantity.toString();
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
                ProductList.quantity++;
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

          // Text(
          //   "${ProductList.quantity}",
          //   style: const CustomTextStyle(size: 16, textColor: greyTextColor),
          // ),
          SizedBox(
            width: 50,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                controller: quantityController,
                validator: (value) {
                  // print("From Validor $value");
                  if (value!.isNotEmpty && value[0] != "-") {
                    if (int.parse(value) > widget.currentStock || int.parse(value)<0) {
                      return "Invalid";
                    }
                  }
                  if(value.isNotEmpty && value[0] == "-"){
                    return "Invalid";
                  }
                  // quantityController.text = value;
                  return null;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  // print(value);
                  if (value.isNotEmpty && value[0] != "-") {
                    if (int.parse(value) <= widget.currentStock ) {
                      ProductList.quantity = int.parse(value);
                    }
                  } 
                  else {
                    // print("Else Chala");
                    ProductList.quantity = 0;
                  }
                },
              ),
            ),
          ),

          const Space05h(),
          // Decrement Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (ProductList.quantity != 0) {
                  ProductList.quantity--;
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
