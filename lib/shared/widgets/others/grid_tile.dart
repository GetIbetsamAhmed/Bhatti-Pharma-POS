import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomGridTile extends StatefulWidget {
  final String text;
  final String image;
  final Function() onTap;
  final double height;
  final double width;
  const CustomGridTile({
    super.key,
    required this.text,
    required this.image,
    required this.onTap,
    this.height = 100,
    this.width = 100,
  });

  @override
  State<CustomGridTile> createState() => _CustomGridTileState();
}

class _CustomGridTileState extends State<CustomGridTile>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  _onTapDown(TapDownDetails details) {
    _controller!.forward();
  }

  _onTapUp(TapUpDetails details) {
    _controller!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - _controller!.value * 0.5;
    return GestureDetector(
      onTap: widget.onTap,
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      child: Transform.scale(
        scale: scale,
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: borderRadius03,
            border: Border.all(
              width: 2,
              color: blueColor,
            ),
            color: borderColor,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  widget.image,
                  height: 41.67,
                  width: 41.67,
                ),
                const SizedBox(height: 07),
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
