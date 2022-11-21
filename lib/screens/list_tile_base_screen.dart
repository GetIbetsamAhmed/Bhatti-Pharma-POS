// ignore_for_file: file_names, prefer_final_fields

import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:flutter/material.dart';

class MyCustomer extends StatefulWidget {
  final String screenTitle;
  final Widget widget;
  final String searchHintText;
  final bool isDataLoaded;
  
  const MyCustomer({
    super.key,
    required this.screenTitle,
    required this.widget,
    this.searchHintText = "Search Here...",
    required this.isDataLoaded,
    
  });

  @override
  State<MyCustomer> createState() => _MyCustomerState();
}

class _MyCustomerState extends State<MyCustomer> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.isDataLoaded
                ? Column(
                    children: [
                      _appBarTile(context, widget.screenTitle),
                      const Space05v(),
                      const Divider(
                        color: borderColor,
                        thickness: 02,
                      ),
                      const Space15v(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: widget.searchHintText,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: borderSide,
                              gapPadding: 02,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: borderSide,
                              gapPadding: 02,
                            ),
                            suffixIcon: const Icon(Icons.search,
                                size: 27, color: greyIconColor),
                          ),
                          cursorHeight: 24,
                        ),
                      ),
                      const Space10v(),
                      Expanded(
                        child: widget.widget,
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: blueColor,
                    ),
                  ),
      ),
    );
  }
}

_appBarTile(BuildContext context, String screenName) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                // Get.back();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            Text(
              screenName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Edit",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}
