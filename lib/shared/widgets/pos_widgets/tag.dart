import 'package:bhatti_pos/services/models/category.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tag extends StatefulWidget {
  final Categories category;
  final Color tagColor;
  final Color textColor;
  final Color borderColor;
  final TextEditingController textController;
  // final int tagId;
  // bool isTapped;
  const Tag({
    super.key,
    required this.category,
    this.borderColor = blueColor,
    this.tagColor = Colors.transparent,
    this.textColor = blueColor,
    required this.textController
    // required this.tagId,
    // required this.isTapped,
  });

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (kDebugMode) {
        print(isSelected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Consumer<CartProvider>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          cart.filter(widget.category);
          widget.textController.clear();
          if (kDebugMode) print("${widget.category.id}");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 05),
          child: Container(
            // height: 20,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              color: value.getTagValue == widget.category.id
                  ? blueColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: value.getTagValue == widget.category.id
                    ? Colors.transparent
                    : blueColor,
              ),
            ),
            child: Center(
              child: Text(
                widget.category.name!,
                style: TextStyle400FW12FS(
                  textColor: value.getTagValue == widget.category.id
                      ? Colors.white
                      : blueColor,
                  weight: value.getTagValue == widget.category.id
                      ? FontWeight.w400
                      : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
