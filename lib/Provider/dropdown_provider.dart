import 'package:flutter/material.dart';
import 'package:weather_app/DropdownButton/dropdown_list.dart';

class DropdownProvider extends ChangeNotifier {
  final LayerLink layerLink = LayerLink();
  final ScrollController controller = ScrollController();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void toggleDropdown(BuildContext context, Function(String) onItemSelected,
      List<String> items) {
    if (_isOpen) {
      _overlayEntry?.remove();
      _isOpen = false;
    } else {
      _overlayEntry = _createOverlayEntry(context, onItemSelected, items);
      Overlay.of(context).insert(_overlayEntry!);
      _isOpen = true;
    }
    notifyListeners();
  }

  OverlayEntry _createOverlayEntry(BuildContext context,
      Function(String) onItemSelected, List<String> items) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                toggleDropdown(context, onItemSelected, items);
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: offset.dy + size.height,
            left: offset.dx,
            width: size.width,
            child: Material(
              color: Colors.transparent,
              child: DropdownList(
                items: items,
                onItemSelected: onItemSelected,
                scrollController: controller,
                layerLink: layerLink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
