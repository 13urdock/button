import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStyles {
  static const background = Color(0xFFFFD74A);
  static const selectedColor = Color(0xFFFFB700);

  static CalendarStyle get calendarStyle => CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: selectedColor,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: selectedColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.black),
        weekendTextStyle: TextStyle(color: Colors.red),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayTextStyle: TextStyle(color: Colors.white),
      );

  static HeaderStyle get headerStyle => HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
}
