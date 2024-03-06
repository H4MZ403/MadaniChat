import 'package:flutter/material.dart';

// *    G R A D I E N T   *
LinearGradient secondGradient = LinearGradient(
  colors: [Colors.yellow[500]!, Colors.yellow[800]!],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

LinearGradient firstGradient = LinearGradient(
  colors: [Colors.yellow[500]!, Colors.yellow[800]!],
  stops: const [0.2, 0.6], // check this if it's right!
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// *    C O L O R S   *

Color grey = const Color(0xFFE1E1E1);
Color iris_100 = const Color(0XFF5D5FEF);
Color customGrey = const Color(0XEE424242);
Color lightGrey = const Color(0XFF868686);
Color grey_333 = const Color(0XFF333333);
Color green = const Color(0X7F05B714);
Color lightRed = const Color(0X1AFF7777);
Color red = const Color(0XFFFF7777);
Color strokeColor = const Color(0XFFCECECE);
Color fontColor = const Color(0XFF868686);
