// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:bhatti_pos/screens/admin/admin_tile_data.dart';
import 'package:bhatti_pos/screens/login/login.dart';
import 'package:bhatti_pos/screens/orders/order_screen.dart';
import 'package:bhatti_pos/screens/pos/pos_customer_screen.dart';
import 'package:bhatti_pos/screens/product/products.dart';
import 'package:bhatti_pos/screens/reports/reports.dart';
import 'package:bhatti_pos/services/utils/shared_preferences.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/widgets/others/logo.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/shared/widgets/others/grid_tile.dart';
import 'package:bhatti_pos/shared/widgets/others/loader.dart';
import 'package:bhatti_pos/shared/widgets/others/screen_ratio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../customers/customer_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool customerDataLoaded = false;
  bool supplierDataLoaded = false;
  bool isDialogOpen = false;
  Loader loader = Loader();

  // Future<void> getUserName() async{
  //   SharedPreferences _instance = await SharedPreferences.getInstance();
  //   UserData.userName = _instance.getString("data")!.split("|")[2];
  //   // print(UserData.userName!);
  // }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) print(UserData.userName);

    // getUserName();
    // if (ProductList.allProducts.isNotEmpty) {
    //   showToast("Products are loaded", Colors.white);
    // } else {
    //   showToast("Products are not loaded", Colors.white);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 500,
                // color: Colors.amber,
                width: 500,
                child: SvgPicture.asset(
                  'assets/background/elipses.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ScreenRatio(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo_Icon
                  const LogoIcon(
                    height: 50,
                    width: 43,
                  ),
                  const Space10v(),
                  // Hello Admin text
                  Row(
                    children: [
                      _showText(
                        "Hello",
                        Colors.black,
                        FontWeight.w400,
                        1,
                        TextOverflow.clip,
                      ),
                      const Space05h(),
                      _showText(
                        UserData.userName!.split(' ')[0],
                        blueColor,
                        FontWeight.w600,
                        1,
                        TextOverflow.clip,
                      ),
                    ],
                  ),
                  const Space10v(),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 01,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Customers
                        CustomGridTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              LTRPageRoute(
                                const CustomersScreen(),
                                100,
                              ),
                            );
                          },
                          image: GridData.customer.imagePath!,
                          text: GridData.customer.text!,
                        ),

                        // Suppliers
                        // CustomGridTile(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         LTRPageRoute(
                        //           MyCustomer(
                        //             screenTitle: "All Suppliers",
                        //             onTap: () {
                        //               Navigator.pop(context);
                        //             },
                        //             widget: ListView.builder(
                        //               padding: const EdgeInsets.symmetric(
                        //                   horizontal: 10),
                        //               itemCount: SupplierList.suppliers.length,
                        //               itemBuilder: (context, index) =>
                        //                   CustomerTile(
                        //                 icon: SvgPicture.asset(
                        //                     "assets/icons/profile.svg",
                        //                     height: 35,
                        //                     width: 25,
                        //                     color: blueColor),
                        //                 customer: SupplierList.suppliers[index],
                        //               ),
                        //             ),
                        //             button: editButton(),
                        //           ),
                        //           100,
                        //         ));
                        //   },
                        //   image: GridData.supplier.imagePath!,
                        //   text: GridData.supplier.text!,
                        // ),

                        // Products
                        CustomGridTile(
                          onTap: () {
                            // loader.hideLoader(context),
                            Navigator.push(
                              context,
                              LTRPageRoute(
                                const ProductScreen(),
                                100,
                              ),
                            );
                          },
                          image: GridData.products.imagePath!,
                          text: GridData.products.text!,
                        ),

                        // POS
                        CustomGridTile(
                          onTap: () {
                            Navigator.of(context).push(
                              LTRPageRoute(
                                const PosCustomerScreen(),
                                100,
                              ),
                            );
                          },
                          image: GridData.pos.imagePath!,
                          text: GridData.pos.text!,
                        ),

                        // Expense
                        // CustomGridTile(
                        //   onTap: () {},
                        //   image: GridData.expense.imagePath!,
                        //   text: GridData.expense.text!,
                        // ),

                        // All Orders
                        CustomGridTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              LTRPageRoute(
                                const OrderScreen(),
                                100,
                              ),
                            );
                          },
                          image: GridData.orders.imagePath!,
                          text: GridData.orders.text!,
                        ),

                        // Reports
                        CustomGridTile(
                          onTap: () {
                            Navigator.of(context).push(
                              LTRPageRoute(
                                const Reports(),
                                100,
                              ),
                            );
                          },
                          image: GridData.reports.imagePath!,
                          text: GridData.reports.text!,
                        ),

                        // // Settings
                        // CustomGridTile(
                        //   onTap: () {},
                        //   image: GridData.settings.imagePath!,
                        //   text: GridData.settings.text!,
                        // ),

                        // About Us
                        // CustomGridTile(
                        //   onTap: () {},
                        //   image: GridData.aboutUs.imagePath!,
                        //   text: GridData.aboutUs.text!,
                        // ),

                        // Logout
                        CustomGridTile(
                          width: MediaQuery.of(context).size.width,
                          onTap: () {
                            _onCloseAppFunction(context);
                          },
                          image: GridData.logout.imagePath!,
                          text: GridData.logout.text!,
                        ),
                      ],
                    ),
                  ),
                  const Space10v(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_showText(text, color, weight, maxlines, overflow) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: weight,
      fontSize: 23,
      color: color,
    ),
    maxLines: maxlines,
    overflow: overflow,
  );
}

Future<void> _logout() async {
  await PreferenceUtils.setString("loginStatus", "F");
  await PreferenceUtils.setString("data", "");
}

_onCloseAppFunction(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Are you sure you wanna quit the app?",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _logout();
            _navigateToLoginScreen(context);
          },
          child: const Text(
            "Yes",
            style: TextStyle(color: blueColor),
          ),
        ),
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.pop(context);
          },
          child: const Text(
            "No",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

_navigateToLoginScreen(BuildContext context) {
  // Navigator.pop(context);
  // Navigator.pushAndRemoveUntil();
  Navigator.pushReplacement(
    context,
    LTRPageRoute(
      const LoginScreen(),
      150,
    ),
  );
}
