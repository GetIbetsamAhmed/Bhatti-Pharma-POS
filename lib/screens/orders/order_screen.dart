// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, unused_element

import 'package:bhatti_pos/services/models/category.dart';
import 'package:bhatti_pos/services/models/order.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/orders_widgets/order_tile.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/shared/widgets/pos_widgets/on_scroll_hide.dart';
import 'package:bhatti_pos/shared/widgets/pos_widgets/tag.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
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
  ScrollController? _controller; // To Control Scroll of filters

  _sortOrdersById() {
    OrderList.allOrders.sort((x, y) => y.orderNo!.compareTo(x.orderNo!));
  }

  bool _isInFilterList(Order order) {
    for (Categories filter in CategoryList.categories) {
      if (order.orderStatus![0] == filter.name![0]) {
        return true;
      }
    }
    return false;
  }

  _setInitialFilter() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.filter(CategoryList.categories[0], false, isOrderFilter: true);
  }

  getAllOrders() async {
    CategoryList.categories.clear();
    CategoryList.categories.add(Categories(id: 0, name: "All"));
    int currentId = 1;
    OrderList.allOrders.clear();
    APIClient _apiClient = APIClient();
    List orders = await _apiClient.getAllOrders(UserData.userName!);

    for (dynamic item in orders) {
      item['CreateDate'] = formatDateTime(item['CreateDate']);
      Order order = Order.fromJson(item);
      OrderList.allOrders.add(order);
      // Inserting the orderStatus in the filter list
      if (!_isInFilterList(order)) {
        Categories filter = Categories(id: currentId, name: order.orderStatus!);
        CategoryList.categories.add(filter);
        currentId++;
      }
    }
    

    // Whenever the screen reloads, all filters must be removed so that we can see all products...
    // This function will perform the task defined above...
    _setInitialFilter();

    // As it is a requirement that all orders must be sorted by Order Number so the function below will
    // perform this task...
    _sortOrdersById();

    showCountToastInApp(orders, "Order");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _searchController = TextEditingController();
      _controller = ScrollController();
      _searchController?.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController?.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        } else {
          return _allOrdersUI(
            context,
            _controller!,
            _searchController!,
          );
        }
      },
    );
  }

  _allOrdersUI(BuildContext context, ScrollController controller,
      TextEditingController searchController) {
    bool searching = false;
    return RefreshIndicator(
      onRefresh: () async {
        await getAllOrders();
      },
      child: Consumer<CartProvider>(
        builder: (context, value, child) => BaseScreen(
          onWillPop: () async {
            value.clearOrderFilter();
            return true;
          },
          screenTitle: "All Orders",
          searchHintText: "Customer name/ Order id/ Area/ Amount",
          controller: searchController,
          onTap: () {
            value.clearOrderFilter();

            Navigator.pop(context);
            searching = false;
          },
          onChanged: (val) {
            value.searchOrderByData(val);
            searching = true;
            if (val.isEmpty) {
              value.clearOrderFilter();
            }
          },
          onSubmit: (val) {
            value.clearOrderFilter();
            searchController.clear();
            searching = false;
          },
          // widget: searching && value.getAllOrders.isEmpty ||
          //         OrderList.allOrders.isEmpty
          //     ? const NoData()
          //     : _ui(value, searching),
          widget: OrderList.allOrders.isEmpty
              ? const NoData()
              : searching
                  ? value.getAllOrders.isEmpty
                      ? const NoData()
                      : _ui(context, value, searching, controller,
                          searchController)
                  // : _ui(context, isSelected, customer, controller,
                  // textController, searching, value)
                  : _ui(
                      context, value, searching, controller, searchController),
          // : _allOrdersUI(context, isSelected, customer, controller,
          //     textController, searching, value),
          showSearch: OrderList.allOrders.isEmpty ? false : true,
        ),
      ),
    );
  }

  _ui(
    BuildContext context,
    CartProvider value,
    bool searching,
    ScrollController controller,
    TextEditingController searchController,
  ) {
    return Column(
      children: [
        ScrollToHide(
          controller: controller,
          enableAnimation: searchController.text.isEmpty ? true : false,
          height: 32,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: CategoryList.categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Tag(
                category: CategoryList.categories[index],
                textController: searchController,
                fromOrderScreen: true,
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: value.getAllOrders.isNotEmpty
                ? value.getAllOrders.length
                : OrderList.allOrders.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: OrderTile(
                order: value.getAllOrders.isNotEmpty
                    ? value.getAllOrders[index]
                    : OrderList.allOrders[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
