import 'package:flutter/material.dart';

class Friend {
  final String? profilePicPath;
  final String name;
  // 스케줄은 모델을 만들어서 해야할지, Todo List로 만들어서 올릴지 고민중이에요

  Friend({
    this.profilePicPath,
    required this.name,
  });
}