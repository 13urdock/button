//단추 메인페이지

import 'package:flutter/material.dart';

import 'danchu_calendar.dart';
import '/src/color.dart';
import '/src/appbar.dart';
import '/src/draggable_style.dart';
import '/diary/selected_diary.dart';
import '/diary/diary_list.dart';

class DanchuPage extends StatefulWidget {
  const DanchuPage({Key? key}) : super(key: key);

  @override
  _DanchuPageState createState() => _DanchuPageState();
}

class _DanchuPageState extends State<DanchuPage> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danchuYellow,
      appBar: MainAppbar(pagename: 'Danchu'),
      body: Stack(
        children: [
          Column(
            children: [
              DanchuCalendar(
                onDaySelected: (selectedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
              ),
              SizedBox(height: 20),
            ],
          ),
          DraggableStyle(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SelectedDiary(selectedDay: _selectedDay),
                DiaryList(
                  selectedDate: _selectedDay,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
