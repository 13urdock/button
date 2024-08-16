import 'package:flutter/material.dart';

import 'package:danchu/models/custom_circle_icon.dart';

class IconSelector extends StatefulWidget {
  final Function(Color) onColorSelected;

  IconSelector({
    required this.onColorSelected,
  });

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  final List<Color> _colors = [
    Color(0xffffc56e),
    Color(0xff80d861),
    Color(0xff6e7dff),
    Color(0xffff6e6e),
    Color(0xffd96eff),
    Color(0xffb7b7b7),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('COLOR'),
      content: Container(
        width: 300,
        height: 50,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                widget.onColorSelected(_colors[index]);
                Navigator.of(context).pop();
              },
              child: CustomCircleIcon(
                  color: _colors[index],
                  isSelected: true,
                ),
              
            );
          },
        ),
      ),
    );
  }
}