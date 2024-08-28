import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TodoItem {
  final String? userId;
  final DateTime date;
  final String title;
  final String description;
  final DateTime? beginTime;
  final DateTime? endTime;
  final Color iconColor;
  final bool isRoutine;
  final bool isAllDay;

  TodoItem({
    this.userId,
    required this.date,
    required this.title,
    required this.description,
    this.beginTime,
    this.endTime,
    required this.iconColor,
    required this.isRoutine,
    required this.isAllDay,
  });

  factory TodoItem.fromSnapshot(String key, Map<dynamic, dynamic> value) {
    return TodoItem(
      userId: key,
      date: DateTime.parse(value['date'] as String),
      title: value['title'] as String,
      description: value['description'] as String,
      beginTime: value['beginTime'] != null ? DateTime.parse(value['beginTime'] as String) : null,
      endTime: value['endTime'] != null ? DateTime.parse(value['endTime'] as String) : null,
      iconColor: Color(value['iconColor'] as int),
      isRoutine: value['isRoutine'] as bool? ?? false,
      isAllDay: value['isAllDay'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'beginTime': beginTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'iconColor': iconColor.value,
      'isRoutine': isRoutine,  // JSON에 isRoutine 추가
      'isAllDay' : isAllDay,
    };
  }
}