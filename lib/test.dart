import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  // Danh sách các mục đã chọn
  List<int> selectedItems = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget 1 - Select Items")),
      body: ListView(
        children: List.generate(6, (index) {
          int item = index + 1;
          return CheckboxListTile(
            title: Text("Item $item"),
            value: selectedItems.contains(item),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedItems.add(item);
                } else {
                  selectedItems.remove(item);
                }
              });
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          // Chuyển đến Widget 2 và chờ kết quả
          List<int>? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActionScreen(selectedItems: selectedItems),
            ),
          );
          if (result != null) {
            setState(() {
              selectedItems = result;
            });
          }
        },
      ),
    );
  }
}

class ActionScreen extends StatelessWidget {
  final List<int> selectedItems;

  ActionScreen({required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget 2 - Add More Items")),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.pop(context, selectedItems);
          },
        ),
      ),
    );
  }
}
