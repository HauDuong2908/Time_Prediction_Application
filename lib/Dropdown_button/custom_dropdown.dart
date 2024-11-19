import 'package:flutter/material.dart';
import 'package:weather_app/Models/dropdown.dart';

typedef _ListItemBuilder = Widget Function(BuildContext context, String result);

class CustomDropdown extends StatefulWidget {
  final Dropdown dropdownModel;
  final Function(String)? onChanged;
  final _ListItemBuilder? listItemBuilder;

  CustomDropdown({
    Key? key,
    required this.dropdownModel,
    this.onChanged,
    this.listItemBuilder,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _controller = ScrollController();
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
      builder: (context) => Stack(
        children: [
          Positioned.fill(
              child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          )),
          Positioned(
            top: offset.dy + size.height,
            left: offset.dx,
            width: size.width,
            child: Material(
              color: Colors.transparent,
              child: _DropdownList(
                items: widget.dropdownModel.items,
                onItemSelected: _onItemSelected,
                scrollController: _controller,
                listItemBuilder: widget.listItemBuilder,
                layerLink: _layerLink,
                borderRadius: widget.dropdownModel.borderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemSelected(String selectedItem) {
    widget.dropdownModel.controller.text = selectedItem;
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
          hintText: widget.dropdownModel.hintText,
          hintStyle: widget.dropdownModel.hintStyle,
          suffixIcon: widget.dropdownModel.fielIcon,
        ),
        child: Text(
          widget.dropdownModel.controller.text.isEmpty
              ? widget.dropdownModel.hintText
              : widget.dropdownModel.controller.text,
          style: widget.dropdownModel.selectedStyle,
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
  final ScrollController scrollController;

  const _DropdownList(
      {Key? key,
      required this.items,
      required this.onItemSelected,
      this.listItemBuilder,
      required this.layerLink,
      this.borderRadius,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: true,
            onDismiss: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        CompositedTransformFollower(
          link: layerLink,
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            borderRadius: borderRadius ?? BorderRadius.circular(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200.0),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                controller: scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () => onItemSelected(items[index]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          listItemBuilder != null
                              ? listItemBuilder!(context, items[index])
                              : ListTile(title: Text(items[index])),
                          const SizedBox(
                            height: 7,
                          ),
                          const Divider(height: 1.0, color: Color(0xF1F1F1F1)),
                        ],
                      ));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
