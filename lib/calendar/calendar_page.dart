import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:danchu/src/color.dart';
import 'package:flutter/src/painting/edge_insets.dart';
import '/src/color.dart';
import '/src/draggable_style.dart';
import 'schedule_list.dart';
import '/src/calendar_style.dart';
import 'add_schedule.dart';

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
            //draggable 기능 추가
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.add), // 스케줄 추가 버튼
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddSchedulePage()), // add_schedule로 이동후 입력한 정보를 가져와서 리스트에 표시함
                    );
                  },
                ),
                TodoList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
