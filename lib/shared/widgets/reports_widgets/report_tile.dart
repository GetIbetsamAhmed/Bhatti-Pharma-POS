import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class ReportTile extends StatefulWidget {
  final double height;
  final String imagePath;
  final String text;
  final Function() onTap;
  const ReportTile({
    super.key,
    this.height = 20,
    required this.imagePath,
    required this.text,
    required this.onTap,
  });

  @override
  State<ReportTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<ReportTile>
    with SingleTickerProviderStateMixin {
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
    double scale = 1 - _controller!.value * 0.3;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: widget.height, bottom: widget.height),
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius05,
            color: borderColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: SvgPicture.asset(
                  widget.imagePath,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.fill,
                ),
              ),
              const Space10v(),
              Text(
                widget.text,
                style: const TextStyle600FW16FS(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
