import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '/src/color.dart';
import 'danchu_calendar.dart';
import 'danchu_draggable.dart';

class DanchuPage extends StatefulWidget {
  const DanchuPage({Key? key}) : super(key: key);

  @override
  _DanchuPageState createState() => _DanchuPageState();
}

class _DanchuPageState extends State<DanchuPage> {
  DateTime _selectedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

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
          DanchuCalendar(onDaySelected: _onDaySelected),
          SizedBox.expand(
            child: DanchuDraggable(selectedDay: _selectedDay),
          ),
        ],
      ),
    );
  }
}
