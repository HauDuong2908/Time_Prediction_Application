import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class locationDropDown extends StatelessWidget {
  const locationDropDown({
    Key? key,
    required this.list,
    required this.initial,
    required this.text,
    required this.onchange,
    this.validator,
  }) : super(key: key);

  final List<String> list;
  final String? initial;
  final String text;
  final ValueChanged<String?> onchange;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      items: list,
      hintText: text,
      initialItem: initial,
      onChanged: onchange,
      validateOnChange: true,
      validator: validator,
    );
  }
}
