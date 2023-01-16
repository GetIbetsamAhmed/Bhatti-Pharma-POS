// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_local_variable

import 'package:bhatti_pos/screens/admin/admin_screen.dart';
import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/screens/pos/pos_product_screen.dart';
import 'package:bhatti_pos/services/models/products/cart_product.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/cart_widgets/cart_product_tile.dart';
import 'package:bhatti_pos/shared/widgets/login_widgets/processing_indicator.dart';
import 'package:bhatti_pos/shared/widgets/others/custom_button.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final Customer customer;
  final bool isOrderEditing; // Either the user is creating or editing order
  final String? orderNumber;
  const CartScreen({
    super.key,
    required this.customer,
    this.isOrderEditing = false,
    this.orderNumber,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  APIClient _apiClient = APIClient();
  TextEditingController? _cartController;
  bool searching = false;

  @override
  void initState() {
    _cartController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _cartController!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) => BaseScreen(
        onWillPop: () async {
          value.clearCartFilters();
          return true;
        },
        screenTitle: widget.customer.customerName!,
        showSearch: value.getAllCarts.isEmpty ? false : true,
        searchHintText: "Product name/ Amount/ Category",
        controller: _cartController,

        button:
            widget.isOrderEditing // If the user is editing any order, then TRUE
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        LTRPageRoute(
                          PosScreen(
                            customer: widget.customer,
                            isOrderEditing: true,
                          ),
                          100,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: blueColor,
                    ))
                : TextButton(
                    child: const Text("Clear All"),
                    onPressed: () {
                      value.clearCarts();
                      Navigator.pop(context);
                    },
                  ),
        // Back button
        onTap: () {
          value.clearCartFilters();
          Navigator.pop(context);
        },
        onChanged: (val) {
          searching = true;
          value.filterCarts(val);
          if (val.isEmpty) {
            searching = false;
          }
        },

        onSubmit: (val) {
          value.clearCartFilters();
          searching = false;
          if (val.isNotEmpty && _cartController != null) {
            _cartController!.clear();
          }
        },
        widget: Stack(
          children: [
            // if the list containing all the carts is empty or the person is searching and
            // the searched list is empty, then the user will be displayed no data or empty cart
            // respectively.
            value.getAllCarts.isEmpty ||
                    searching && value.getFilteredCarts.isEmpty
                ? NoData(
                    text: !searching ? "Cart is empty" : "No data to display",
                  )
                : Column(
                    // Displaying all products saved in the cart
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: searching
                              ? value.getFilteredCarts.length
                              : value.getAllCarts.length,
                          itemBuilder: (context, index) => StatefulBuilder(
                            builder: (context, state) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 08, right: 08, bottom: 10.0),
                              child: CartProductTile(
                                product: searching
                                    ? value.getFilteredCarts[index]
                                    : value.getAllCarts[index],
                                controller: _cartController!,
                                isEditingOrder: widget.isOrderEditing,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!searching) const SizedBox(height: 80),
                    ],
                  ),

            // Button Total Price to be payed
            if (!searching)
              Positioned(
                bottom: 10,
                left: MediaQuery.of(context).size.width * 0.01,
                child: Consumer<CartProvider>(
                  builder: (context, value, child) => CustomElevatedButton(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.98,
                    onTap: () async {
                      if (kDebugMode) {
                        print("Ontap");
                        for (CartProduct product in value.getAllCartProducts) {
                          print(
                              "product Id is ${product.productId} and product Name ${product.productName}");
                        }
                      }

                      _showConfirmationDialog(value);
                    },
                    color: blueColor,
                    text: "Confirm order",
                    // "Total payable amount = ${regulateNumber(double.parse(value.getTotalPrice().toStringAsFixed(2)))}",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<String> _postOrder(List<Map<String, dynamic>> allOrders) async {
    // Create Objects
    String userName = UserData.userName!;
    int customerId = widget.customer.id!;

    Map<String, dynamic> body = {
      "CustomerID": customerId,
      "Username": userName,
      "Items": allOrders,
    };
    // Post All Data
    return await _apiClient.postOrder(body);
  }

  Future<String> _editOrder(List<Map<String, dynamic>> allOrders) async {
    // Create Objtects
    int orderNumber = int.parse(widget.orderNumber!);

    Map<String, dynamic> body = {
      "Orderno": orderNumber,
      "Items": allOrders,
    };

    if (kDebugMode) print(body.toString());

    // Edit All Orders
    return await _apiClient.editOrders(body);
  }

  List<Map<String, dynamic>> _formatData(CartProvider provider) {
    if (widget.isOrderEditing) {
      return _formatCartProductsForUpdatingOrder(provider);
    } else {
      return _formatCartProductsForCreatingOrder(provider);
    }
  }

  List<Map<String, dynamic>> _formatCartProductsForUpdatingOrder(
      CartProvider provider) {
    List<Map<String, dynamic>> allOrders = [];

    for (CartProduct product in provider.getAllCartProducts) {
      double discount =
          (product.unitPrice / 100 * product.discount) * product.quantity;
      Map<String, dynamic> order = {
        "ProductID": product.productId,
        "Quantity": product.quantity,
        "UnitPrice": product.unitPrice,
        "GrossAmount":
            product.unitPrice * product.quantity, // Unit price * quantity
        "Discount": discount, // discount (in PKR) * quantity
        "Amount": product.totalPrice,
      };
      allOrders.add(order);
    }
    return allOrders;
  }

  List<Map<String, dynamic>> _formatCartProductsForCreatingOrder(
      CartProvider provider) {
    // Creating map of corresponding required fields or all cart products and
    // Maintaining a list of map containing required fields to post order
    List<Map<String, dynamic>> allOrders = [];
    // add them to the list
    for (CartProduct product in provider.getAllCartProducts) {
      Map<String, dynamic> order = {
        "ProductID": product.productId,
        "Quantity": product.quantity,
        "UnitPrice": product.unitPrice,
        "GrossAmount":
            product.unitPrice * product.quantity, // Unit price * quantity
        "Discount":
            product.discount * product.quantity, // discount (in PKR) * quantity
        "Amount": product.totalPrice,
      };
      allOrders.add(order);
    }
    return allOrders;
  }

  _showConfirmationDialog(CartProvider provider) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Text(
          "Confirm Order?",
          style: CustomTextStyle(
            textColor: blueColor,
            size: 20,
            weight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "The total payable price is",
              textAlign: TextAlign.center,
              style: CustomTextStyle(size: 14),
            ),
            const Space05v(),
            Text(
              // "PKR ${regulateNumber(double.parse(provider.getTotalPrice().toStringAsFixed(2)))}",
              "PKR ${provider.getTotalPrice().toStringAsFixed(2)}",
              textAlign: TextAlign.center,
              style: const TextStyle600FW16FS(
                textColor: blueColor,
              ),
            ),
          ],
        ),
        actions: [
          // Confirm Button
          TextButton(
            onPressed: () async {
              String data = "";
              // Maintaining a list of map containing required fields to post order
              List<Map<String, dynamic>> _formattedOrders = [];

              // Format all cart products before creating order
              _formattedOrders = _formatData(provider);

              LoginWidgets.processingIndicator(context);

              // Hittin the api
              if (widget.isOrderEditing) {
                data = await _editOrder(_formattedOrders);
              } else {
                data = await _postOrder(_formattedOrders);
              }
              // Closing the loading indicator.
              LoginWidgets.closeProcessingIndicator(context);

              if (data.contains("Successfully")) {
                provider.clearCarts();
                Navigator.pushAndRemoveUntil(context,
                    LTRPageRoute(const AdminScreen(), 100), (route) => false);
              } else {
                // Closing Dialog
                Navigator.pop(context);
              }
            },
            child: const Text(
              "Confirm",
              style: CustomTextStyle(
                textColor: blueColor,
                weight: FontWeight.bold,
              ),
            ),
          ),

          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              "Cancel",
              style: CustomTextStyle(
                textColor: Colors.red,
                weight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
