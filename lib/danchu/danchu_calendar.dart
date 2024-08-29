import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '/src/color.dart';

class DanchuCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final Set<DateTime> markedDates;
  const DanchuCalendar({
    Key? key,
    required this.onDaySelected,
    required this.markedDates,
  }) : super(key: key);

  @override
  _DanchuCalendarState createState() => _DanchuCalendarState();
}

class _DanchuCalendarState extends State<DanchuCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onDaySelected(selectedDay);
        },
        calendarStyle: CalendarStyles.calendarStyle,
        headerStyle: CalendarStyles.headerStyle,
        calendarBuilders: CalendarStyles.calendarBuilders,
        eventLoader: (day) {
          return widget.markedDates
                  .contains(DateTime(day.year, day.month, day.day))
              ? [DateTime(day.year, day.month, day.day)]
              : [];
        },
      ),
    );
  }
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
        formatButtonVisible: false,
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
