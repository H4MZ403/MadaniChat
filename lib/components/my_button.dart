import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String title;
  final double fontSize;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool shadowEnabled;
  final Color? fontColor;
  final BoxBorder? border;
  const MyButton({
    super.key,
    this.title = 'Click Me',
    this.fontSize = 12,
    this.margin = EdgeInsets.zero,
    this.color = Colors.blue,
    this.shadowEnabled = true,
    this.fontColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: shadowEnabled ? boxShadow : null,
        border: border,
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.judson(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
