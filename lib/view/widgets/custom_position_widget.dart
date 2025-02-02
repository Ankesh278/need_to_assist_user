import 'package:flutter/material.dart';

class PositionedWidget extends StatelessWidget {
  final double top;
  final double left;
  final double width;
  final double height;
  final Widget child;

  const PositionedWidget({
    super.key,
    required this.top,
    required this.left,
    required this.width,
    required this.height,
    required this.child, // Accepts any widget
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        width: width,
        height: height,
        child: child, // Flexible child widget
      ),
    );
  }
}
