import 'package:flutter/material.dart';
import '../utils/utils.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const CustomContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: boxShadow,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: padding,
      child: child,
    );
  }
}
