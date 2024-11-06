import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  final Color primaryColor = const Color(0xff90B2F9);
  final Color secondaryColor = const Color(0xff90B2F9);
  final Color blue1 = const Color(0xff2281ec);
  final LinearGradient myGradient = const LinearGradient(
    colors: [Color.fromARGB(255, 14, 60, 99), Colors.blue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    // stops: [0.3, 0.7],
  );
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 71, 146, 221),
      Color.fromARGB(255, 39, 101, 163),
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}
