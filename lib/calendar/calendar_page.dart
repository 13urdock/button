import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '/src/color.dart';
import 'calendar.dart';
import 'calendar_draggable.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.danchuYellow,
        appBar: AppBar(
          title: Text('Danchu Calendar'),
          backgroundColor: AppColors.danchuYellow,
        ),
        body: Stack(children: [
          Calendar(),
          CalendarDraggable(),
        ]));
  }
}
