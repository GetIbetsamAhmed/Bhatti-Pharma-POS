// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable

import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/orders_widgets/order_tile.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base_screen/basescreen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController? _searchController;
  getAllOrders() async {
    OrderList.allOrders = [];
    APIClient _apiClient = APIClient();
    List orders = await _apiClient.getAllOrders(UserData.userName!);

    for (dynamic item in orders) {
      item['CreateDate'] = formatDateTime(item['CreateDate']);
      Order order = Order.fromJson(item);
      OrderList.allOrders.add(order);
    }
    if (kDebugMode){
      print("Total Orders to be desplayed are ${OrderList.allOrders.length}");
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController?.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        } else {
          return _allOrders(_searchController!);
        }
      },
    );
  }
}

_allOrders(TextEditingController controller) {
  bool searching = false;
  return Consumer<CartProvider>(
    builder: (context, value, child) => BaseScreen(
      onWillPop: () async {
        value.clearOrderFilter();
        return true;
      },
      screenTitle: "All Orders",
      searchHintText: "Customer name/ Order id/ Area",
      controller: controller,
      onTap: () {
        value.clearOrderFilter();
        Navigator.pop(context);
        searching = false;
      },
      onChanged: (val) {
        value.searchOrderByData(val);
        searching = true;
      },
      onSubmit: (val) {
        value.clearOrderFilter();
        controller.clear();
        searching = false;
      },
      widget:
          searching && value.getAllOrders.isEmpty || OrderList.allOrders.isEmpty
              ? const NoData()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: searching
                      ? value.getAllOrders.length
                      : OrderList.allOrders.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: OrderTile(
                      order: searching
                          ? value.getAllOrders[index]
                          : OrderList.allOrders[index],
                    ),
                  ),
                ),
      showSearch: OrderList.allOrders.isEmpty ? false : true,
    ),
  );
}
