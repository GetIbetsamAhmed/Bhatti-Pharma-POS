import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHide extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final double height;
  final double width;
  final bool enableAnimation;
  final double negativeHeight;
  const ScrollToHide({
    super.key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 300),
    required this.height,
    required this.width,
    this.enableAnimation = true,
    this.negativeHeight = 10,
  });

  @override
  State<ScrollToHide> createState() => _ScrollToHideState();
}

class _ScrollToHideState extends State<ScrollToHide> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    isVisible = true;
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(listen);
  }

  listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void hide() {
    if (isVisible && widget.enableAnimation) {
      setState(
        () => isVisible = false,
      );
    }
  }

  void show() {
    if (!isVisible && widget.enableAnimation) {
      setState(() {
        isVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          height: isVisible ? widget.height : 0,
          curve: Curves.ease,
          // width: widget.width,
          duration: widget.duration,
          // color: blueColor,
          child: widget.child,
        ),
        SizedBox(height: widget.negativeHeight),
      ],
    );
  }
}
