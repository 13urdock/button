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
    Color(0xffffc56e),
    Color(0xff80d861),
    Color(0xff6e7dff),
    Color(0xffff6e6e),
    Color(0xffd96eff),
    Color(0xffb7b7b7),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: GridView.builder(// itembuilder 전까지 gridview 사이즈 설정
        shrinkWrap: true,
        itemCount: _colors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _colors.length, // 한 줄에 들어갈 아이콘들의 개수
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) { // 선택된 아이콘 색깔 리턴함
          bool isSelected = _selectedColor == _colors[index];
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: CustomCircleIcon(
              isSelected: !isSelected, // 여기서 isSelected를 반전시킵니다.
              onPressed: () {
                setState(() {
                  _selectedColor = _colors[index];
                });
                widget.onColorSelected(_selectedColor);
                Navigator.of(context).pop(_selectedColor);
              },
              color: _colors[index],
            ),
          );
        },
      ),
    );
  }
}