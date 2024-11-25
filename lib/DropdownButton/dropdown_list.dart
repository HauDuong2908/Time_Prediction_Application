import 'package:flutter/material.dart';

typedef _ListItemBuilder = Widget Function(BuildContext context, String result);

class DropdownList extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemSelected;
  final _ListItemBuilder? listItemBuilder;
  final LayerLink layerLink;
  final BorderRadius? borderRadius;
  final ScrollController scrollController;

  const DropdownList(
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
