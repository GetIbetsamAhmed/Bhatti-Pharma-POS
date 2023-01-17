// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/screens/customers/edit_customer_screen.dart';
import 'package:bhatti_pos/screens/customers/services/get_all_customers.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/customer_widgets/customer_tile.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../base_screen/basescreen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  TextEditingController? _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
    if (kDebugMode) print("Init called");
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
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

  _customerUI(BuildContext context, TextEditingController controller) {
    bool searching = false;
    return Consumer<CartProvider>(
      builder: (context, value, child) => BaseScreen(
        onWillPop: () async {
          value.clearCustomerFilter();
          return true;
        },
        screenTitle: "All Customers",
        searchHintText: "Customer name/ Phone/ Area",
        showSearch: CustomerList.customers.isEmpty ? false : true,
        showFloating: true,
        onTap: () {
          Navigator.pop(context);
          searching = false;
          value.clearCustomerFilter();
        },
        controller: controller,
        onChanged: (val) {
          searching = true;
          value.filterCustomerByName(val);
          if (val.isEmpty) {
            value.clearCartFilters();
          }
        },
        onSubmit: (val) {
          value.clearCustomerFilter();
          controller.clear();
          // value.clearCustomerFilter();
          searching = false;
        },
        widget: searching && value.getCustomers.isEmpty ||
                CustomerList.customers.isEmpty
            ? const NoData()
            : NotificationListener<ScrollNotification>(
                onNotification: closeKeyboardOnScroll,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: value.getCustomers.length + 1,
                  itemBuilder: (context, index) {
                    if (index < value.getCustomers.length) {
                      return createCustomer(
                          controller, value, index, searching);
                    } else{
                      return const SizedBox(height: 70);
                    }
                  },
                ),
              ),
        onFloatingPressed: () {
          Navigator.push(
            context,
            BRTTLPageRoute(
              const EditCustomer(
                text: "Create Customer",
                customerIndex: -1,
              ),
              250,
            ),
          );
        },
        floatingButtonIcon: Icons.add,
      ),
    );
  }

  createCustomer(TextEditingController controller, CartProvider value,
      int index, bool searching) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: CustomerTile(
        onTap: () {
          controller.clear();
          Navigator.push(
            context,
            BRTTLPageRoute(
              EditCustomer(
                text: "Edit Customer",
                customerIndex: value.getCustomers[index].id!,
              ),
              300,
            ),
          );
          value.clearCustomerFilter();
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
    );
  }
}
