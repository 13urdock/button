import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_style.dart';
import 'package:danchu/color.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danchuYellow,
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Container(
        margin: const EdgeInsets.all(6.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (
            selectedDay,
            focusedDay,
          ) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyles.calendarStyle,
          headerStyle: CalendarStyles.headerStyle,
        ),
      ),
    );
  }
}
