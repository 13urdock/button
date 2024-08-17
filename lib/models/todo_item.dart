import 'package:danchu/models/custom_circle_icon.dart';
import 'package:flutter/material.dart';

// todo list
class TodoItem {
  final DateTime? date;
  final String title;
  final String description;
  final DateTime? beginTime;
  final DateTime? endTime;
  final bool isRoutine;
  final List<DateTime>? routine;

  TodoItem({
    required this.date,
    required this.title,
    required this.description,
    this.beginTime,
    this.endTime,
    required this.isRoutine,
    this.routine,
    //this.icon,
  });
}