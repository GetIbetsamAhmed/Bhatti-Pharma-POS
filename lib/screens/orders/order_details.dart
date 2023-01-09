// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/models/order_details.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/orders_widgets/order_details_tile.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Order Details Controller
  TextEditingController? _orderSearchController;
  bool searching = false;

  @override
  void initState() {
    _orderSearchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _orderSearchController!.dispose();
    super.dispose();
  }

  double subTotal = 0.0;

  double discountedPrice = 0.0;

  double totalAmount = 0.0;

  getOrderDetails() async {
    OrderList.orderDetails = [];
    APIClient _apiClient = APIClient();
    List data = await _apiClient.getOrderDetails(widget.order.orderNo!);
    for (dynamic item in data) {
      OrderDetails details = OrderDetails.fromJson(item);
      OrderList.orderDetails.add(details);
      subTotal += (details.unitPrice! * details.quantity!);
      // discountedPrice += details.discount! * details.quantity!;
      discountedPrice += details.discount! * details.quantity!;
      totalAmount += details.payableAmount!;
    }
    // totalAmount = subTotal - discountedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomProgressIndicator();
          } else {
            return Consumer<CartProvider>(
              builder: (context, value, child) => BaseScreen(
                onWillPop: () async {
                  value.clearOrderDetailSFilter();
                  return true;
                },
                searchHintText: "Product name/ Payable amount",
                screenTitle: widget.order.customerFirstName!,
                showSearch: OrderList.orderDetails.isEmpty ? false : true,
                widget: OrderList.orderDetails.isEmpty ||
                        searching && value.orderDetails.isEmpty
                    ? const NoData()
                    : _orderDetailsUI(
                        context,
                        // if the user is searching then the UI will be displayed the data containing the
                        // searched order other wise they will be displayed all details that are fetched from
                        // the api accordingly
                        searching ? value.orderDetails : OrderList.orderDetails,
                        widget.order.createDate!,
                        subTotal,
                        discountedPrice,
                        totalAmount,
                        value,
                      ),
                onChanged: (val) {
                  searching = true;
                  value.filterOrderDetails(val);
                  if (val.isEmpty) {
                    searching = false;
                  }
                },
                onTap: () {
                  Navigator.pop(context);
                },
                onSubmit: (val) {
                  value.clearOrderDetailSFilter();
                  _orderSearchController!.clear();
                  searching = false;
                },
                controller: _orderSearchController!,
              ),
            );
          }
        },
      ),
    );
  }

  _orderDetailsUI(
    BuildContext context,
    List<OrderDetails> data,
    String orderDate,
    double subTotal,
    double discount,
    double totalPrice,
    CartProvider provider,
  ) {
    return Consumer<CartProvider>(
      builder: (context, value, child) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // color: blueColor,

          ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index < data.length) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 08, right: 08, bottom: 10.0),
                  child: OrderDetailTile(
                    order: data[index],
                    orderCreateDate: orderDate,
                  ),
                );
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.24,
                );
              }
            },
          ),

          if (searching == false)
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                height: MediaQuery.of(context).size.height * 0.23,
                decoration: BoxDecoration(
                  // border: border,
                  color: blueColor,
                  borderRadius: borderRadiusTopOnly(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Space05v(),
                    // Subtotal
                    _computedData(
                      "Sub Total",
                      subTotal.toStringAsFixed(2),
                      true,
                    ),

                    // Discounted Price
                    _computedData(
                      "Discount",
                      discount.toStringAsFixed(2),
                      true,
                    ),

                    // Total Price
                    _computedData(
                      "Total Price",
                      totalPrice.toStringAsFixed(2),
                      false,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

_computedData(String name, String value, bool isNotLast) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle600FW16FS(textColor: shadedWhite)),
          Text(value, style: const TextStyle600FW16FS(textColor: shadedWhite)),
        ],
      ),
      if (isNotLast) const Divider(height: 15, color: shadedWhite),
    ],
  );
}
