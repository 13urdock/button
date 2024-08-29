import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Set<DateTime> _markedDates = {};

  @override
  void initState() {
    super.initState();
    _fetchMarkedDates();
  }

  void _fetchMarkedDates() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('danchu').get();

    setState(() {
      _markedDates = snapshot.docs.map((doc) {
        Timestamp timestamp = doc['date'] as Timestamp;
        return DateTime(
          timestamp.toDate().year,
          timestamp.toDate().month,
          timestamp.toDate().day,
        );
      }).toSet();
    });
  }

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
                markedDates: _markedDates,
              ),
              SizedBox(height: 20),
            ],
          ),
          DraggableStyle(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SelectedDiary(selectedDay: _selectedDay),
                DiaryList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
