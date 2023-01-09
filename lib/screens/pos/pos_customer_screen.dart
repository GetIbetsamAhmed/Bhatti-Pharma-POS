// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/screens/customers/services/get_all_customers.dart';
import 'package:bhatti_pos/screens/pos/pos_product_screen.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/customer_widgets/customer_tile.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PosCustomerScreen extends StatefulWidget {
  const PosCustomerScreen({super.key});

  @override
  State<PosCustomerScreen> createState() => _PosCustomerScreenState();
}

class _PosCustomerScreenState extends State<PosCustomerScreen> {
  TextEditingController? _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    CartProvider().setAllCustomers(CustomerList.customers);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllCustomers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        } else {
          return _customerUI(context, _searchController!);
        }
      },
    );
  }
}

_customerUI(context, TextEditingController controller) {
  bool searching = false;
  return Consumer<CartProvider>(
    builder: (context, value, child) => BaseScreen(
      onWillPop: () async {
        value.clearCustomerFilter();
        return true;
      },
      screenTitle: "POS Customers",
      searchHintText: "Customer name/ Phone/ Area",
      onTap: () {
        value.clearCustomerFilter();
        Navigator.pop(context);
        searching = false;
      },
      controller: controller,
      onChanged: (val) {
        value.filterCustomerByName(val);
        searching = true;
      },
      onSubmit: (val) {
        _clearFilter(value, controller);
        searching = false;
      },
      showSearch: CustomerList.customers.isEmpty ? false : true,
      widget: searching && value.getCustomers.isEmpty ||
              CustomerList.customers.isEmpty
          ? const NoData()
          : NotificationListener<ScrollNotification>(
              onNotification: closeKeyboardOnScroll,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: searching
                    ? value.getCustomers.length
                    : CustomerList.customers.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomerTile(
                    canCopy: false,
                    onTap: () {
                      _clearCarts(context);
                      closeKeyBoard();
                      value.clearProductFilters(true);
                      Navigator.push(
                        context,
                        LTRPageRoute(
                          PosScreen(
                            customer: value.getCustomers[index],
                          ),
                          100,
                        ),
                      );
                      _clearFilter(value, controller);
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/profile.svg",
                      height: 35,
                      width: 25,
                      color: blueColor,
                    ),
                    customer: searching
                        ? value.getCustomers[index]
                        : CustomerList.customers[index],
                  ),
                ),
              ),
            ),
    ),
  );
}

_clearFilter(CartProvider value, TextEditingController controller) {
  value.clearCustomerFilter();
  controller.clear();
}

_clearCarts(BuildContext context) {
  final cart = Provider.of<CartProvider>(context, listen: false);
  cart.setCartLists([]);
  cart.setTotalPrice(0.0);
  cart.setCount(0);
}
