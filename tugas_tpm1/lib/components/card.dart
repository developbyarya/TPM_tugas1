import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Color? bgColor;
  final Widget? child;
  final double? width;
  const CustomCard({super.key, this.bgColor, this.child, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      width: width,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,

    );
  }
}