import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  final Color primaryColor = const Color(0xff90B2F9);
  final Color secondaryColor = const Color(0xff90B2F9);
  final Color blue1 = const Color(0xff2281ec);
  final LinearGradient myGradient = LinearGradient(
    colors: [const Color.fromARGB(255, 14, 60, 99), Colors.blue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    // stops: [0.3, 0.7],
  );
}
