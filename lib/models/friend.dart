import 'package:flutter/material.dart';

class Friend {
  final String friendId;
  final String userId;
  final String status; // accepted, pending, denied

  Friend({
    required this.friendId,
    required this.userId,
    required this.status,
  });
}