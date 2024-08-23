import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '/src/color.dart';
import 'calendar.dart';
import 'calendar_draggable.dart';
import 'show_calendar.dart';
import 'show_friend_list.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay){
    setState((){
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
      body: 
      Column(
        children: [
          ShowFriendList(),
          Expanded(
            child: Stack(
              children: [
                ShowCalendar(onDaySelected: _onDaySelected),
                CalendarDraggable(selectedDay: _selectedDay),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
