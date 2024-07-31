import 'package:flutter/material.dart';
import '/src/calendar_style.dart';
import '/src/draggable_style.dart';
import '/src/color.dart';

class DanchuPage extends StatefulWidget {
  const DanchuPage({Key? key});

  @override
  _DanchuPageState createState() => _DanchuPageState();
}

class _DanchuPageState extends State<DanchuPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danchuYellow,
      appBar: AppBar(
        title: Text('Danchu Calendar'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Stack(
        children: [
          Calendar(),
          DraggableScrollable(
            //draggable 부분
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'yyyy년 MM월 dd일',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
