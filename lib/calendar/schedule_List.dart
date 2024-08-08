import 'package:danchu/models/todo_item.dart';
import 'package:flutter/material.dart';

import '../src/color.dart';
import '../models/todo_item.dart';
// 일정 리스트 띄우는 화면

class TodoList extends StatefulWidget {
  // statefulWidget으로 바꿉니다 위젯 상태가 계속 변하기 때문에
  List<TodoItem> todos = []; // calendar_draggble에 있는 todoItems를 저장함

  TodoList({required this.todos}); // calendar_draggable로부터 아이템을 받으려면 있어야해요

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // 리스트 띄우는 화면
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: widget.todos.asMap().entries.map((entry) {
        final index = entry.key;
        final todo = entry.value;
        return Dismissible(
          // 삭제할 수 있는 위젯
          key: Key(todo.title), // TodoItem의 title을 key로 사용
          onDismissed: (direction) {
            // right to left scroll only
            setState(() {
              widget.todos.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              //삭제된 후 스낵바 메세지 띄우기
              SnackBar(content: Text('${todo.title} 삭제됨')),
            );
          },
          background: Container(color: AppColors.deepYellow),
          child: ListTile(
            title: Text(todo.title),
          ),
        );
      }).toList(),
    );
  }
}
