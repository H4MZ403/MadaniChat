import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obsecureText;
  final String hintText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.obsecureText,
    required this.hintText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool obsecureTextVar = widget.obsecureText;

  void toggleObsecureState() {
    setState(() {
      obsecureTextVar = !obsecureTextVar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
      child: TextField(
        controller: widget.controller,
        cursorColor: Colors.yellow[600],
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.3),
            fontSize: 16,
          ),
        ),
        obscureText: widget.obsecureText,
      ),
    );
  }
}
