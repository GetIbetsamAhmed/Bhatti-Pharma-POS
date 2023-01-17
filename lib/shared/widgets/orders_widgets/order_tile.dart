// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_element

import 'package:bhatti_pos/screens/cart/cart_screen.dart';
import 'package:bhatti_pos/screens/orders/order_details.dart';
import 'package:bhatti_pos/services/models/products/cart_product.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/models/order_details.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/login_widgets/processing_indicator.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatefulWidget {
  final Order order;
  const OrderTile({
    super.key,
    required this.order,
  });

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  double subTotal = 0.0;
  double discountedPrice = 0.0;
  double totalAmount = 0.0;

  // bool? isOrderComplete;

  getOrderDetails() async {
    OrderList.orderDetails.clear();
    CartProvider provider = context.read<CartProvider>();
    provider.clearCarts();
    APIClient _apiClient = APIClient();
    List? data = await _apiClient.getOrderDetails(widget.order.orderNo!);
    if (data != null) {
      // The if block below is to check that either the order is comppleted or not
      // If the case completed, then the user will be navigated to the Order Detials Screen
      // If not the case, then the user will be navigated to the Edit Order screen which is basically the
      // cart screen with several modifications
      if (widget.order.orderStatus!.toLowerCase().contains("complete")) {
        // Order Details Screen

        for (dynamic item in data) {
          OrderDetails details = OrderDetails.fromJson(item);
          OrderList.orderDetails.add(details);
          subTotal += (details.unitPrice! * details.quantity!);
          // discountedPrice += details.discount! * details.quantity!;
          discountedPrice += details.discount! * details.quantity!;
          totalAmount += details.payableAmount!;
        }
      } else {
        // Edit Order Screen

        for (dynamic item in data) {
          // print(widget.order.createDate!);
          double difference =
              (item['UnitPrice'] / 100 * item['Discount']) * item['Quantity'];

          CartProduct details = CartProduct(
            customerName: widget.order.customerFirstName!,
            productId: item['ProductID'],
            productName: item['ProductName'],
            categoryName: item['CategoryName'],
            quantity: item['Quantity'],
            totalPrice:
                double.parse((item['Amount'] - difference).toStringAsFixed(2)),
            dateTime: widget.order
                .createDate!, //DateTime.parse( widget.order.createDate!).millisecondsSinceEpoch,
            unitPrice: item['UnitPrice'],
            currentStock: item['CurrentStock'] <= 0
                ? item['Quantity']
                : item['CurrentStock'],
            discount: double.parse(item['Discount'].toString()),
          );
          provider.addCart(details);
        }
      }
    }
    // totalAmount = subTotal - discountedPrice;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // On tap of an order, two steps are to be covered.
        // 1) fetch all details of the order.
        // 2) Navigate on the screen with the data fetched according to the status of the order

      onTap: () async {
        // Step 1 => Fetching data
        LoginWidgets.processingIndicator(context);
        await getOrderDetails();
        LoginWidgets.closeProcessingIndicator(context);

        // Step 2 => Conditional Navigation
        if (widget.order.orderStatus!.toLowerCase().contains("complete")) {
          Navigator.push(
            context,
            LTRPageRoute(
              OrderDetailsScreen(
                order: widget.order,
                subTotal: subTotal,
                discountedPrice: discountedPrice,
                totalAmount: totalAmount,
              ),
              100,
            ),
          );
        } else {
          Navigator.push(
            context,
            LTRPageRoute(
              CartScreen(
                customer:
                    Customer(customerName: widget.order.customerFirstName!),
                isOrderEditing: true,
                orderNumber: widget.order.orderNo,
              ),
              100,
            ),
          );
        }
      },
      child: Container(
        // padding: const EdgeInsets.all(10),
        // margin: const EdgeInsets.only(bottom: 10, left: 05, right: 05),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(01),
            color: bgColor,
            border: border),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order status
                  _orderStatusBagde(),
                  const Space10v(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showTextWithTwoColors("", "${widget.order.orderNo}"),
                      Text(
                        "PKR. ${widget.order.netAmount!}",
                        style: const TextStyle600FW16FS(),
                      ),
                    ],
                  ),
                  const Space05v(),

                  // Customer Name tile
                  Text(
                    "${widget.order.customerFirstName}",
                    style: const TextStyle600FW16FS(),
                  ),
                  const Space05v(),
                  // Area Name

                  Text(
                    widget.order.area!,
                    style: const TextStyle400FW12FS(
                      textColor: greyTextColor,
                    ),
                  ),

                  const Divider(),
                  // Order Create Date
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${widget.order.createDate}",
                      style: const TextStyle400FW12FS(
                        textColor: greyTextColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
              textColor: blueColor, weight: FontWeight.w600),
        ),
      ],
    );
  }

  _orderStatusBagde() {
    bool isOrderCompleted =
        widget.order.orderStatus!.toLowerCase().contains("complete");
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.only(left: 5, bottom: 2, top: 2, right: 10),
        decoration: BoxDecoration(
            color: isOrderCompleted ? tagGreenColor : tagBlueColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isOrderCompleted ? greenColor : blueColor, width: 0.3)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOrderCompleted)
              const Icon(
                Icons.done,
                color: greenColor,
                size: 15,
              ),
            if (!isOrderCompleted)
              const CircleAvatar(
                backgroundColor: blueColor,
                radius: 3,
              ),
            const Space05h(),
            Text(
              widget.order.orderStatus!,
              style: TextStyle400FW12FS(
                textColor: isOrderCompleted ? greenColor : blueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Chevron extends CustomPainter {
  bool? showBlue;

  Chevron(bool shouldShowBlue) {
    showBlue = shouldShowBlue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // const Gradient gradient = LinearGradient(
    //   begin: Alignment.topCenter,
    //   end: Alignment.bottomCenter,
    //   colors: [Colors.orangeAccent, Colors.yellow],
    //   tileMode: TileMode.clamp,
    // );

    // final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = Paint()..color = borderColorDark;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(15, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
