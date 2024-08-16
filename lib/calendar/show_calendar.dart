import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar.dart';
import '../src/color.dart';

class ShowCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const ShowCalendar({Key? key, required this.onDaySelected}) : super(key: key);

  @override
  _ShowCalendarState createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    widget.onDaySelected(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danchuYellow,
      body: Calendar(
        selectedDay: _selectedDay,
        focusedDay: _focusedDay,
        onDaySelected: _onDaySelected,
      ),
    );
  }
}