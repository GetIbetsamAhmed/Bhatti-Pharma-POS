// ignore_for_file: iterable_contains_unrelated_type, no_leading_underscores_for_local_identifiers, unused_element

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/screens/cart/cart_screen.dart';
import 'package:bhatti_pos/services/models/category.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/services/models/products/product.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/cart_widgets/cart_icon.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/shared/widgets/pos_widgets/on_scroll_hide.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:bhatti_pos/shared/widgets/pos_widgets/pos_tile.dart';
import 'package:bhatti_pos/shared/widgets/pos_widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PosScreen extends StatefulWidget {
  final Customer customer;
  final bool isOrderEditing;
  const PosScreen({
    super.key,
    required this.customer,
    this.isOrderEditing = false,
  });

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  late ScrollController controller;
  TextEditingController? _searchController;

  @override
  dispose() {
    super.dispose();
    controller.dispose();
    _searchController!.dispose();
  }

  getAllProducts() async {
    APIClient _apiClient = APIClient();
    // Clear the list because this list is also used to save all data of product screen
    // Doing this to prevent data redundency
    ProductList.allProducts.clear();

    // fetching all products from api
    List products = await _apiClient.getAllProducts();
    // List of all Objects of Products
    for (int index = 0; index < products.length; index++) {
      // Creating the object containing the reference of the instance to the Main Product Screen
      Product product = Product.fromJson(products[index], index);
      ProductList.allProducts.add(product);
    }
    // print(CartProvider().getProducts.length);
  }

  getAllCategories() async {
    CategoryList.categories.clear();
    // Initial Category
    CategoryList.categories.add(Categories(id: 0, name: "All"));

    // Fetching all categories from api
    APIClient _apiClient = APIClient();
    // List of all objects of Categories
    List allCategories = await _apiClient.getAllCategories();
    for (dynamic instance in allCategories) {
      Categories category = Categories.fromJson(instance);
      CategoryList.categories.add(category);
    }
  }

  _setInitialFilter() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.filter(CategoryList.categories[0], false);
  }

  fetchData() async {
    await getAllProducts();
    await getAllCategories();
    // Initially, the filter selected is all product...
    _setInitialFilter();
    _searchController?.clear();
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        } else {
          return _productUI(
            context,
            _searchController!,
            widget.customer,
            controller,
          );
        }
      },
    );
  }

  _productUI(
    BuildContext context,
    TextEditingController textController,
    Customer customer,
    ScrollController controller,
  ) {
    bool searching = false;

    return Consumer<CartProvider>(
      builder: (context, value, child) => BaseScreen(
        onWillPop: () async {
          if (!widget.isOrderEditing) {
            value.clearPOSProductFilters();
          }
          return true;
        },
        screenTitle: widget.customer.customerName!,
        controller: textController,
        searchHintText: "Product Name/ Unit Price",
        onChanged: (val) {
          searching = true;
          value.filterPOSProductsByString(val);
          if (val.isEmpty) {
            value.clearPOSProductFilters(fromPOSCustomers: false);
          }
        },
        onSubmit: (val) {
          value.clearPOSProductFilters();
          textController.clear();
          searching = false;
        },
        showSearch: ProductList.allProducts.isEmpty ? false : true,
        widget: ProductList.allProducts.isEmpty
            ? const NoData()
            // : searching
            //     ? value.getProductsForPOS.isEmpty
            //         ? const NoData()
            //         : _posUI(context, customer, controller, textController,
            //             searching, value)
            : _posUI(context, customer, controller, textController, searching,
                value),

        // showSearch: false,
        bottomSpacing: 05,
        onTap: () {
          final cartList = Provider.of<CartProvider>(context, listen: false);
          cartList.filter(CategoryList.categories[0], true);
          Navigator.pop(context);
          value.clearPOSProductFilters();
          searching = false;
        },
        button: widget.isOrderEditing
            ? null
            : IconButton(
                iconSize: 25,
                onPressed: () {
                  if (widget.isOrderEditing) {
                    Navigator.pop(context);
                  } else {
                    final cart =
                        Provider.of<CartProvider>(context, listen: false);
                    if (cart.getCount == 0) {
                      showToast("Nothing is added to the cart", Colors.white);
                    } else {
                      // Navigation will be done here...
                      closeKeyBoard();
                      Navigator.push(
                        context,
                        LTRPageRoute(
                          CartScreen(
                            customer: customer,
                          ),
                          100,
                        ),
                      );
                    }
                  }
                },
                icon: const Cart(),
              ),
      ),
    );
  }

  _posUI(
    context,
    Customer customer,
    ScrollController controller,
    TextEditingController textController,
    bool searching,
    CartProvider value,
    // bool productList,
  ) {
    // print(searching);
    return Column(
      children: [
        ScrollToHide(
          controller: controller,
          enableAnimation: textController.text.isEmpty ? true : false,
          height: 32,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: CategoryList.categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Tag(
                category: CategoryList.categories[index],
                textController: textController,
              );
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: value.getProductsForPOS.isNotEmpty
                ? GridView.builder(
                    controller: controller,
                    itemCount: value.getProductsForPOS.isNotEmpty
                        ? value.getProductsForPOS.length
                        : ProductList.allProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 145,
                    ),
                    itemBuilder: (context, index) {
                      return POSTile(
                        // data: value.getProductsForPOS.isNotEmpty
                        // ? value.getProductsForPOS[index]
                        // : ProductList.allProducts[index],
                        data: value.getProductsForPOS[index],
                        customer: customer,
                        index: index,
                      );
                    },
                  )
                : const NoData(),
          ),
        ),
      ],
    );
  }
}
