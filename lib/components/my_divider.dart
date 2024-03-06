import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 21,
        vertical: 0,
      ),
      child: Divider(
        height: 0,
        thickness: 0.5,
        color: grey,
      ),
    );
  }
}
