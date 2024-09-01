import 'package:danchu/danchu/danchu_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'danchu_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Map<DateTime, Color> _markedDates = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _danchuStream;

  @override
  void initState() {
    super.initState();
    _fetchMarkedDates();
  }

  void _fetchMarkedDates() {
    //마커 넣을 날짜
    final User? user = _auth.currentUser;
    if (user != null) {
      _danchuStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('danchu')
          .snapshots();

      _danchuStream.listen((snapshot) {
        setState(() {
          _markedDates = Map.fromEntries(snapshot.docs.map((doc) {
            Timestamp timestamp = doc['date'] as Timestamp;
            String emotion = doc['danchu'] as String;
            return MapEntry(
              DateTime(
                timestamp.toDate().year,
                timestamp.toDate().month,
                timestamp.toDate().day,
              ),
              Danchu.getDanchuColor(emotion),
            );
          }));
        });
      });
    }
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
            ],
          ),
          DraggableStyle(
            //draggable
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
