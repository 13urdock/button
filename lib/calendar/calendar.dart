import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:danchu/src/color.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const Calendar({
    Key? key,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.danchuYellow,
      ),
      margin: const EdgeInsets.all(6.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,
        calendarStyle: CalendarStyles.calendarStyle,
        headerStyle: CalendarStyles.headerStyle,
        calendarBuilders: CalendarStyles.calendarBuilders,
      ),
    );
  }
}

class CalendarStyles {
  static CalendarStyle get calendarStyle => CalendarStyle(
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
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );

  static CalendarBuilders get calendarBuilders => CalendarBuilders(
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