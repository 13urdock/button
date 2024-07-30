import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_style.dart';
import '../colorpallet.dart'; // 색상 팔레트 파일을 import 합니다.

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Color _selectedColor = Colors.blue; // 선택된 색상을 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalendarStyles.background,
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: CalendarStyles.background,
      ),
      body: Column(
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
            ),
          ),
          ElevatedButton(
            child: Text('Tap here'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedColor, // 버튼 색상을 선택된 색상으로 설정
            ),
            onPressed: () {
              showColorPalette(
                context,
                (color) {
                  setState(() {
                    _selectedColor = color; // 선택된 색상 업데이트
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
