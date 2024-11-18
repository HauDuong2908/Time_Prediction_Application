import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Dropdown Demo'),
          centerTitle: true,
        ),
        body: const Center(
          child: DropdownExample(),
        ),
      ),
    );
  }
}

class DropdownExample extends StatefulWidget {
  const DropdownExample({Key? key}) : super(key: key);

  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomDropdown(
            items: _items,
            controller: _controller,
            hintText: 'Select an option',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            selectedStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            borderRadius: BorderRadius.circular(8),
            fillColor: Colors.grey[200],
            onChanged: (value) {
              print('Selected value: $value');
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // In ra giá trị đã chọn
              print('Current selected value: ${_controller.text}');
            },
            child: const Text('Get Selected Value'),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final List<String>? items;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Function(String)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.borderRadius,
    this.fillColor,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      items: items?.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: selectedStyle ?? const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: hintStyle,
      ),
      onChanged: (value) {
        controller.text = value ?? '';
        if (onChanged != null) {
          onChanged!(value!);
        }
      },
    );
  }
}
