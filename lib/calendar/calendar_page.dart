import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_style.dart';
import 'package:danchu/src/color.dart';
import 'schedule_page.dart';
import 'package:flutter/src/painting/edge_insets.dart';
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
          Calendar(),
          DraggableScrollable(
            //darrable 기능 추가
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: ;
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
