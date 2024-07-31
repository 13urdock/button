import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPalette extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPalette({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('색상 선택'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: Colors.blue,
          onColorChanged: (color) {
            onColorSelected(color);
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showColorPalette(BuildContext context, Function(Color) onColorSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ColorPalette(onColorSelected: onColorSelected);
    },
  );
}