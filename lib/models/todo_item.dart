import 'package:flutter/material.dart';

// todo list
class TodoItem {
  final String title;
  final String description;
  final DateTime? dueDate;
  final IconData icon;

  TodoItem({
    required this.title,
    required this.description,
    this.dueDate,
    required this.icon,
  });
}