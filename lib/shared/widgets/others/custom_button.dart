import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final Function() onTap;
  final Color color;

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double? width;
  const CustomElevatedButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
    this.fontSize = 16,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w500,
    this.borderRadius = 05,
    this.height = 40,
    this.width,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton>
    with SingleTickerProviderStateMixin {
  bool isButtonTap = false;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
  }

  _onTapDown(TapDownDetails details) {
    _controller!.forward();
  }

  _onTapUp(TapUpDetails details) {
    _controller!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - _controller!.value * 0.2;
    return SizedBox(
      height: widget.height,
      width: widget.width == null? MediaQuery.of(context).size.width: widget.width!,
      child: Transform.scale(
        scale: scale,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.color,
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.textColor,
                  fontWeight: widget.fontWeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
