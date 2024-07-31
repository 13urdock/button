import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'danchu_style.dart';
import 'package:danchu/src/color.dart';
import 'danchu_banner.dart';

//캘린더 페이지
class danchuPage extends StatefulWidget {
  const danchuPage({super.key});

  @override
  _danchuPageState createState() => _danchuPageState();
}

class _danchuPageState extends State<danchuPage> {
  DateTime _selectedDay = DateTime.now(); //초기날짜
  DateTime _focusedDay = DateTime.now(); //선택날짜

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danchuYellow, //전체 화면 색상 설정(maincolor)
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(6.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyles.calendarStyle,
              headerStyle: CalendarStyles.headerStyle,
              calendarBuilders: CalendarStyles.calendarBuilders,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SchedulePage(
                  selectedDay: _selectedDay,
                  scrollController: scrollController,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
