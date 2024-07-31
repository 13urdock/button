import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:danchu/src/color.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class CalendarStyles {
  static CalendarStyle get calendarStyle => CalendarStyle(
        //calendar style
        selectedDecoration: BoxDecoration(
          color: AppColors.deepYellow,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.deepYellow.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: AppColors.nomalText),
        weekendTextStyle: TextStyle(color: AppColors.sundayred),
        selectedTextStyle: TextStyle(color: AppColors.white),
        todayTextStyle: TextStyle(color: AppColors.white),
      );

  static HeaderStyle get headerStyle => HeaderStyle(
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );

  static CalendarBuilders get calendarBuilders => CalendarBuilders(
        //주말 색변경
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                'Sun',
                style: TextStyle(color: AppColors.sundayred),
              ),
            );
          }
          if (day.weekday == DateTime.saturday) {
            return Center(
              child: Text(
                'Sat',
                style: TextStyle(color: AppColors.saturdayblue),
              ),
            );
          }
          return null;
        },
        defaultBuilder: (context, day, focusedDay) {
          if (day.weekday == DateTime.saturday) {
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: AppColors.saturdayblue),
              ),
            );
          }
          if (day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: AppColors.sundayred),
              ),
            );
          }
          return null;
        },
      );
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;

  @override
  Widget build(BuildContext context) {
    //calendar
    return Scaffold(
      backgroundColor: AppColors.danchuYellow,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(6.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarStyle: CalendarStyles.calendarStyle,
              headerStyle: CalendarStyles.headerStyle,
              calendarBuilders: CalendarStyles.calendarBuilders,
            ),
          ),
        ],
      ),
    );
  }
}
