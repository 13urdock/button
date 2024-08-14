import 'package:flutter/material.dart';
import '/src/draggable_style.dart';
import 'danchu_calendar.dart';
import 'package:danchu/diary/diary_list.dart';
import '/src/color.dart';
import '/diary/diary_entry.dart';
import '/diary/diary_module.dart';

class DanchuPage extends StatefulWidget {
  const DanchuPage({Key? key}) : super(key: key);

  @override
  _DanchuPageState createState() => _DanchuPageState();
}

class _DanchuPageState extends State<DanchuPage> {
  Map<DateTime, DiaryEntry> diaries = {};
  DateTime _selectedDay = DateTime.now();

  void _addOrUpdateEntry(DiaryEntry diaryEntry) {
    setState(() {
      DateFunction.addOrUpdateEntry(diaries, diaryEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    DiaryEntry? selectedDayEntry =
        DateFunction.getSelectedDayEntry(diaries, _selectedDay);

    return Scaffold(
      backgroundColor: AppColors.danchuYellow,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.danchuYellow,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {},
          child: Image.asset('assets/White_logo.png'),
        ),
        title: Text('Danchu'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {},
              child: Image.asset('assets/menu.png'),
            ),
          )
        ],
      ),
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
                DiaryContentWidget(
                  selectedDayEntry: selectedDayEntry,
                  selectedDay: _selectedDay,
                  onAddOrUpdateEntry: _addOrUpdateEntry,
                ),
                DiaryList(
                  diaries: diaries.values.toList()
                    ..sort((a, b) => b.date.compareTo(a.date)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
