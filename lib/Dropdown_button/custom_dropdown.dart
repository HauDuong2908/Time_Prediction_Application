import 'package:flutter/material.dart';

typedef _ListItemBuilder = Widget Function(BuildContext context, String result);

class CustomDropdown extends StatefulWidget {
  final List<String>? items;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final BorderRadius? borderRadius;
  final Widget? fieldSuffixIcon;
  final Function(String)? onChanged;
  final _ListItemBuilder? listItemBuilder;

  CustomDropdown({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.borderRadius,
    this.listItemBuilder,
    this.fieldSuffixIcon,
    this.onChanged,
  })  : assert(items!.isNotEmpty),
        assert(controller.text.isEmpty || items!.contains(controller.text)),
        super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _overlayEntry?.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      setState(() {
        _isOpen = true;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height,
        left: offset.dx,
        width: size.width,
        child: Material(
          color: Colors.transparent,
          child: _DropdownList(
            items: widget.items!,
            onItemSelected: _onItemSelected,
            listItemBuilder: widget.listItemBuilder,
            layerLink: _layerLink,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }

  void _onItemSelected(String selectedItem) {
    widget.controller.text = selectedItem;
    if (widget.onChanged != null) {
      widget.onChanged!(selectedItem);
    }
    _toggleDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Select Value',
          hintStyle: widget.hintStyle,
          suffixIcon: widget.fieldSuffixIcon,
        ),
        child: Text(
          widget.controller.text.isEmpty
              ? widget.hintText ?? ''
              : widget.controller.text,
          style: widget.selectedStyle ?? const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class _DropdownList extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemSelected;
  final _ListItemBuilder? listItemBuilder;
  final LayerLink layerLink;
  final BorderRadius? borderRadius;

  const _DropdownList({
    Key? key,
    required this.items,
    required this.onItemSelected,
    this.listItemBuilder,
    required this.layerLink,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: layerLink,
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: items.map((item) {
            return InkWell(
              onTap: () => onItemSelected(item),
              child: listItemBuilder != null
                  ? listItemBuilder!(context, item)
                  : ListTile(title: Text(item)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
