import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Models/dropdown.dart';
import 'package:weather_app/Provider/dropdown_provider.dart';

typedef _ListItemBuilder = Widget Function(BuildContext context, String result);

class CustomDropdown extends StatelessWidget {
  final Dropdown dropdownModel;
  final Function(String)? onChanged;
  final _ListItemBuilder? listItemBuilder;

  const CustomDropdown({
    Key? key,
    required this.dropdownModel,
    this.onChanged,
    this.listItemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DropdownProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () {
          provider.toggleDropdown(
            context,
            (selectedItem) {
              dropdownModel.controller.text = selectedItem;
              if (onChanged != null) {
                onChanged!(selectedItem);
              }
            },
            dropdownModel.items,
          );
        },
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: dropdownModel.hintText,
            hintStyle: dropdownModel.hintStyle,
            suffixIcon: dropdownModel.fielIcon,
          ),
          child: Text(
            dropdownModel.controller.text.isEmpty
                ? dropdownModel.hintText
                : dropdownModel.controller.text,
            style: dropdownModel.selectedStyle,
          ),
        ),
      );
    });
  }
}
