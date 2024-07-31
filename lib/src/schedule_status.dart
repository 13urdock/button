import 'package:flutter/material.dart';

class ToDoLabel extends StatefulWidget {
  const ToDoLabel({super.key});

  @override
  State<ToDoLabel> createState() => _ToDoLabelState();
}

class _ToDoLabelState extends State<ToDoLabel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.volume_up), // icon 
          onPressed: () {
            // 여기 수정
          },
        ),
        
      ],
    );
  }
}