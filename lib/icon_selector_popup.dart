import 'package:flutter/material.dart';
import 'src/custom_todo_icon.dart';

class IconSelector extends StatefulWidget {
  final Function(Color) onColorSelected;

  IconSelector({required this.onColorSelected});

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  Color _selectedColor = Colors.blue;

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _colors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return CustomCircleIcon(
            isSelected: _selectedColor == _colors[index],
            onPressed: () {
              setState(() {
                _selectedColor = _colors[index];
              });
              widget.onColorSelected(_selectedColor);
              Navigator.of(context).pop();
            },
            color: _colors[index],
          );
        },
      ),
    );
  }
}