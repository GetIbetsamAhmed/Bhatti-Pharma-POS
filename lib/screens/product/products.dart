// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/services/models/product.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/others/no_data.dart';
import 'package:bhatti_pos/shared/widgets/others/progress_indicator.dart';
import 'package:bhatti_pos/shared/widgets/product_widgets/product_tile.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController? _searchController;

  getAllProducts() async {
    ProductList.allProducts = [];
    APIClient _apiClient = APIClient();
    List products = await _apiClient.getAllProducts();
    // print("product "+product.length.toString());
    for (int index = 0; index < products.length; index++) {
      Product product = Product.fromJson(products[index], index);
      ProductList.allProducts.add(product);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool searching = false;
    return FutureBuilder(
      future: getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        } else {
          return Consumer<CartProvider>(
            builder: (context, value, child) => BaseScreen(
              onWillPop: () async {
                value.clearProductFilters(false);
                return true;
              },
              searchHintText: "Product name/ Unit price/ Category",
              screenTitle: "All Products",
              controller: _searchController!,
              showSearch: ProductList.allProducts.isEmpty ? false : true,
              onChanged: (val) {
                value.filterProductsByString(val, false);
                searching = true;
              },
              onSubmit: (val) {
                value.clearProductFilters(false);
                _searchController?.clear();
                searching = false;
              },
              onTap: () {
                Navigator.pop(context);
                searching = false;
                value.clearProductFilters(false);
              },
              widget: searching && value.getProductsForProducts.isEmpty ||
                      ProductList.allProducts.isEmpty
                  ? const NoData()
                  : NotificationListener<ScrollNotification>(
                      onNotification: closeKeyboardOnScroll,
                      child: ListView.builder(
                        itemCount: searching
                            ? value.getProductsForProducts.length
                            : ProductList.allProducts.length,
                        itemBuilder: (context, index) => ProductTile(
                          product: searching
                              ? value.getProductsForProducts[index]
                              : ProductList.allProducts[index],
                        ),
                      ),
                    ),
            ),
          );
        }
      },
      // ),
    );
  }
}
