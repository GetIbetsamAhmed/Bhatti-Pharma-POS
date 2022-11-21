// // ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element, use_build_context_synchronously

// import 'package:bhatti_pos/sample_data/customer_data.dart';
// import 'package:bhatti_pos/services/models/product.dart';
// import 'package:bhatti_pos/services/utils/apiClient.dart';
// import 'package:bhatti_pos/services/utils/preference_utils.dart';
// import 'package:bhatti_pos/shared/transition/left_to_right.dart';
// import 'package:bhatti_pos/shared/admin_tile_list.dart';
// import 'package:bhatti_pos/screens/list_tile_base_screen.dart';
// import 'package:bhatti_pos/screens/login.dart';
// import 'package:bhatti_pos/shared/constants/colors.dart';
// import 'package:bhatti_pos/shared/constants/spaces.dart';
// import 'package:bhatti_pos/shared/widgets/customer_tile.dart';
// import 'package:bhatti_pos/shared/widgets/grid_tile.dart';
// import 'package:bhatti_pos/shared/widgets/loader.dart';
// import 'package:bhatti_pos/shared/widgets/product_tile.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AdminScreen extends StatefulWidget {
//   const AdminScreen({super.key});

//   @override
//   State<AdminScreen> createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   bool customerDataLoaded = false;
//   bool productDataLoaded = false;
//   bool supplierDataLoaded = false;
//   List<Product> allProductsApi = [];
//   APIClient? _apiClient;
//   bool isDialogOpen = false;
//   Loader loader = Loader();

//   _allProducts() async {
//     // print(isDialogOpen.toString() + " " + productDataLoaded.toString());
//     allProductsApi = await _apiClient!.getAllProducts();
//     if (allProductsApi.isNotEmpty) {
      
//         supplierDataLoaded = true;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _apiClient = APIClient();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Logo_Icon
//         Image.asset(
//           "assets/logo/logo_icon.png",
//           alignment: Alignment.topLeft,
//           fit: BoxFit.fill,
//         ),
//         const Space10v(),
//         // Hello Admin text
//         Row(
//           children: [
//             _showText(
//               "Hello",
//               Colors.black,
//               FontWeight.w400,
//               1,
//               TextOverflow.clip,
//             ),
//             const Space05h(),
//             _showText(
//               "Ibtesam Ahmed ".split(' ')[0],
//               blueColor,
//               FontWeight.w600,
//               1,
//               TextOverflow.clip,
//             ),
//           ],
//         ),

//         const Space10v(),

//         Expanded(
//           child: GridView(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//             ),
//             children: [
//               // Customers
//               CustomGridTile(
//                 onTap: () {
//                   Get.to(
//                     MyCustomer(
//                       screenTitle: "All Customers",
//                       isDataLoaded: true,
//                       widget: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         itemCount: allCustomers.length,
//                         itemBuilder: (context, index) => CustomerTile(
//                           icon: SvgPicture.asset("assets/icons/profile.svg",
//                               height: 35, width: 25, color: blueColor),
//                           customer: allCustomers[index],
//                         ),
//                       ),
//                     ),
//                     transition: Transition.leftToRight,
//                     duration: const Duration(milliseconds: 200),
//                   );
//                 },
//                 image: data[0]['image'],
//                 text: data[0]['text'],
//               ),

//               // Suppliers
//               CustomGridTile(
//                 onTap: () {
//                   Get.to(
//                     MyCustomer(
//                       screenTitle: "All Suppliers",
//                       isDataLoaded: true,
//                       widget: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         itemCount: allCustomers.length,
//                         itemBuilder: (context, index) => CustomerTile(
//                           icon: SvgPicture.asset("assets/icons/profile.svg",
//                               height: 35, width: 25, color: blueColor),
//                           customer: allCustomers[index],
//                         ),
//                       ),
//                     ),
//                     transition: Transition.leftToRight,
//                     duration: const Duration(milliseconds: 200),
//                   );
//                 },
//                 image: data[1]['image'],
//                 text: data[1]['text'],
//               ),

//               // Products
//               CustomGridTile(
//                 onTap: () {
//                   _allProducts();
//                   !productDataLoaded
//                       ? loader.showLoader(context)
//                       : {
//                           // loader.hideLoader(context),
//                           Get.to(MyCustomer(
//                             screenTitle: "Order Lists",
//                             widget: ListView.builder(
//                                 itemCount: allProductsApi.length,
//                                 itemBuilder: (context, index) => ProductTile(
//                                     product: allProductsApi[index])),
//                             isDataLoaded: true,
//                           ))
//                         };

//                   // _allProducts();
//                   // productDataLoaded? Get.to(
//                   //   MyCustomer(
//                   //     screenTitle: "Orders List",
//                   //     isDataLoaded: true,
//                   //     widget: ListView.builder(
//                   //       padding: const EdgeInsets.symmetric(horizontal: 10),
//                   //       itemCount: allProductsApi.length,
//                   //       itemBuilder: (context, index) => ProductTile(product: allProductsApi[index])
//                   //     ),
//                   //   ),
//                   //   transition: Transition.leftToRight,
//                   //   duration: const Duration(milliseconds: 200),
//                   // ): customDialog(context);
//                 },
//                 image: data[2]['image'],
//                 text: data[2]['text'],
//               ),

//               // POS
//               CustomGridTile(
//                 onTap: () {},
//                 image: data[3]['image'],
//                 text: data[3]['text'],
//               ),

//               // Expense
//               CustomGridTile(
//                 onTap: () {},
//                 image: data[4]['image'],
//                 text: data[4]['text'],
//               ),

//               // All Orders
//               CustomGridTile(
//                 onTap: () {},
//                 image: data[5]['image'],
//                 text: data[5]['text'],
//               ),

//               // Reports
//               CustomGridTile(
//                 onTap: () {},
//                 image: data[6]['image'],
//                 text: data[6]['text'],
//               ),

//               // Settings
//               CustomGridTile(
//                 onTap: () {},
//                 image: data[7]['image'],
//                 text: data[7]['text'],
//               ),

//               // About Us
//               CustomGridTile(
//                 onTap: () {},
//                 image: data[8]['image'],
//                 text: data[8]['text'],
//               ),

//               // Logout
//               CustomGridTile(
//                 onTap: () {
//                   _onCloseAppFunction(context);
//                 },
//                 image: data[9]['image'],
//                 text: data[9]['text'],
//               ),
//             ],
//           ),
//         ),
//         const Space10v(),
//       ],
//     );
//   }
// }

// _showText(text, color, weight, maxlines, overflow) {
//   return Text(
//     text,
//     style: TextStyle(
//       fontWeight: weight,
//       fontSize: 23,
//       color: color,
//     ),
//     maxLines: maxlines,
//     overflow: overflow,
//   );
// }

// Future<void> _logout() async {
//   // SharedPreferences _instance = await SharedPreferences.getInstance();
//   // if (kDebugMode) {
//   //   print(_instance.getKeys());
//   // }
//   // await _instance.setString("loginStatus", "F");
//   // if (kDebugMode) {
//   //   print(_instance.getKeys());
//   // }
//   await PreferenceUtils.setString("loginStatus", "F");
// }

// _onCloseAppFunction(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text(
//         "Are you sure you wanna quit the app?",
//         textAlign: TextAlign.left,
//         style: TextStyle(fontSize: 15),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             _logout();
//             _navigateToLoginScreen(context);
//           },
//           child: const Text(
//             "Yes",
//             style: TextStyle(color: blueColor),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             // Popping back
//             Navigator.pop(context);
//           },
//           child: const Text(
//             "No",
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// _navigateToLoginScreen(BuildContext context) {
//   return Navigator.pushReplacement(
//     context,
//     LTRPageRoute(
//       const LoginScreen(),
//       600,
//     ),
//   );
// }
