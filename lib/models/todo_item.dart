import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  final String? id;
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
    this.id,
    this.userId,
    required this.date,
    required this.title,
    required this.description,
    this.beginTime,
    this.endTime,
    required this.iconColor,
    this.isRoutine = false,
    this.isAllDay = false,
  });

  factory TodoItem.fromSnapshot(String key, Map<dynamic, dynamic> value) {
    return TodoItem(
      id: key,
      userId: value['userId'] as String?,
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

  factory TodoItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TodoItem(
      id: doc.id,
      userId: data['userId'] as String?,
      date: (data['date'] as Timestamp).toDate(),
      title: data['title'] as String,
      description: data['description'] as String,
      beginTime: data['beginTime'] != null ? (data['beginTime'] as Timestamp).toDate() : null,
      endTime: data['endTime'] != null ? (data['endTime'] as Timestamp).toDate() : null,
      iconColor: Color(data['iconColor'] as int),
      isRoutine: data['isRoutine'] as bool? ?? false,
      isAllDay: data['isAllDay'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'title': title,
      'description': description,
      'beginTime': beginTime != null ? Timestamp.fromDate(beginTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'iconColor': iconColor.value,
      'isRoutine': isRoutine,
      'isAllDay': isAllDay,
    };
  }
}