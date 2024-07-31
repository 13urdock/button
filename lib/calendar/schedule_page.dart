import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  final DateTime selectedDay;
  final ScrollController scrollController;

  const SchedulePage({
    Key? key,
    required this.selectedDay,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일 일정',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}