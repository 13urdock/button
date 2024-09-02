import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'calendar.dart';
import '../src/color.dart';

class ShowCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const ShowCalendar({Key? key, required this.onDaySelected}) : super(key: key);

  @override
  _ShowCalendarState createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  Map<DateTime, int> _eventCounts = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      print('로그인하세요');
      return;
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .get();

      Map<DateTime, int> eventCounts = {};
      for (var doc in snapshot.docs) {
        DateTime date = (doc['date'] as Timestamp).toDate();
        DateTime dateKey = DateTime(date.year, date.month, date.day);
        eventCounts[dateKey] = (eventCounts[dateKey] ?? 0) + 1;
      }

      setState(() {
        _eventCounts = eventCounts;
      });
    } catch (error) {
      print("데이터 로딩 오류: $error");
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    widget.onDaySelected(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danchuYellow,
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        calendarStyle: CalendarStyle(
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
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final eventCount = _eventCounts[DateTime(date.year, date.month, date.day)] ?? 0;
            if (eventCount > 0) {
              return Positioned(
                bottom: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(eventCount > 3 ? 3 : eventCount, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 0.8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.deepYellow,
                      ),
                      width: 6.0,
                      height: 6.0,
                    );
                  }),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}