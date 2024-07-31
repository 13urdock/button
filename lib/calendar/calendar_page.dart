import 'package:flutter/material.dart';
import '/src/color.dart';
import '/src/draggable_style.dart';
import 'schedule_list.dart';
import '/src/calendar_style.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

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
        title: Text('Schedule Calendar'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Stack(
        children: [
          Calendar(
            //calendar 기능추가
            selectedDay: _selectedDay,
            focusedDay: _focusedDay,
            onDaySelected: (
              selectedDay,
              focusedDay,
            ) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          DraggableScrollable(
            //darrable 기능 추가
            child: Stack(
              children: [
                Expanded(
                  child: ScheduleList(selectedDay: _selectedDay),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ScheduleList(selectedDay: _selectedDay),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
