import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHide extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final double height;
  final double width;
  final bool enableAnimation;
  const ScrollToHide({
    super.key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 300),
    required this.height,
    required this.width,
    this.enableAnimation = true,
  });

  @override
  State<ScrollToHide> createState() => _ScrollToHideState();
}

class _ScrollToHideState extends State<ScrollToHide> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
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
    return AnimatedContainer(
      height: isVisible ? widget.height : 0,
      curve: Curves.ease,
      // width: widget.width,
      duration: widget.duration,
      // color: blueColor,
      child: widget.child,
    );
  }
}
