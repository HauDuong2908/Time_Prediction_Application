import 'package:flutter/material.dart';

typedef _ListItemsBuilder = Widget Function(
    BuildContext context, String result);

class Dropdown {
  final List<String> items;
  final TextEditingController controller;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle selectedStyle;
  final BorderRadius borderRadius;
  final Widget fielIcon;

  Dropdown({
    required this.items,
    required this.controller,
    required this.hintText,
    required this.hintStyle,
    required this.selectedStyle,
    required this.borderRadius,
    required this.fielIcon,
  });
}
