// ignore_for_file: file_names, prefer_final_fields, unused_field

import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/widgets/others/logo.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final String screenTitle;
  final Widget widget;
  final String searchHintText;
  final bool showSearch;
  final Widget? button;
  final double bottomSpacing;
  final bool showDivider;
  final Function() onTap;
  final Function(String) onChanged;
  final Function(String)? onSubmit;
  final TextEditingController? controller;
  final bool showFloating;
  final Function()? onFloatingPressed;
  final IconData? floatingButtonIcon;
  final Future<bool> Function() onWillPop;
  final bool showSecondatyTitle;
  final String secondaryTitle;

  const BaseScreen({
    super.key,
    required this.screenTitle,
    required this.widget,
    this.searchHintText = "Search Here...",
    this.showSearch = true,
    this.button,
    this.bottomSpacing = 5.0,
    required this.onTap,
    this.showDivider = true,
    required this.onChanged,
    this.onSubmit,
    this.controller,
    this.onFloatingPressed,
    this.showFloating = false,
    this.floatingButtonIcon,
    required this.onWillPop,
    this.showSecondatyTitle = false,
    this.secondaryTitle = "",
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  bool isSelected = false;
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: WillPopScope(
          onWillPop: widget.onWillPop,
          child: SafeArea(
            child: Column(
              children: [
                _appBarTile(
                  widget.screenTitle,
                  widget.secondaryTitle,
                  widget.button == null
                      ? const LogoIcon(height: 40, width: 40)
                      : widget.button!,
                  ontap: widget.onTap,
                ),
                SizedBox(height: widget.bottomSpacing),
                if (widget.showDivider)
                  const Divider(
                    color: borderColor,
                    thickness: 02,
                  ),
                if (widget.showSearch)
                  SizedBox(height: widget.bottomSpacing + 4),
                if (widget.showSearch)
                  SizedBox(
                    // height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: widget.controller,
                        decoration: InputDecoration(
                          hintText: widget.searchHintText,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: borderSide,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: borderSide,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            size: 21,
                            color: greyIconColor,
                          ),
                        ),
                        minLines: 1,
                        style: const TextStyle(fontSize: 14),
                        cursorHeight: 18,
                        onChanged:
                            widget.showSearch ? widget.onChanged : (value) {},
                        onSubmitted:
                            widget.showSearch ? widget.onSubmit : (value) {},
                      ),
                    ),
                  ),
                if (widget.showDivider) const Space10v(),
                Expanded(
                  child: widget.widget,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: widget.showFloating
            ? FloatingActionButton(
                onPressed: widget.onFloatingPressed,
                backgroundColor: Colors.white,
                elevation: 10,
                child: Icon(
                  widget.floatingButtonIcon!,
                  color: blueColor,
                  size: 21,
                ),
              )
            : null,
      ),
    );
  }

  _appBarTile(String screenName, String secondaryData, Widget button,
      {required Function() ontap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: ontap,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.61,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screenName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.showSecondatyTitle) const SizedBox(height: 3),
                    if (widget.showSecondatyTitle && widget.secondaryTitle != "")
                      Text(
                        secondaryData,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: blueColor
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              // if (widget.showScreenNameInColor)
              //   Container(
              //     padding: const EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       // color: blueColor,
              //       borderRadius: BorderRadius.circular(3),
              //     ),
              //     child: Center(
              //       child: Text(
              //         screenName,
              //         style: const TextStyle(
              //           fontWeight: FontWeight.w800,
              //           fontSize: 16,
              //           color: blueColor,
              //         ),
              //         maxLines: 1,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ),
              //   ),
            ],
          ),
          button,
        ],
      ),
    );
  }
}
