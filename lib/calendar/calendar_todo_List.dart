import 'package:danchu/models/custom_circle_icon.dart';
import 'package:danchu/models/todo_item.dart';
import 'package:flutter/material.dart';

import '../src/color.dart';
import '../models/todo_item.dart';
import '../models/custom_circle_icon.dart';

// 일정 리스트 띄우는 화면

class TodoList extends StatelessWidget {
  final List<TodoItem> todoItems;
  final Function(TodoItem) onDelete;

  TodoList({required this.todoItems, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    print("TodoList: 총 ${todoItems.length}개의 일정이 있습니다.");

    if (todoItems.isEmpty) {
      return Center(child: Text("일정이 없습니다."));
    }

    try {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: todoItems.length,
          itemBuilder: (context, index) {
            final todo = todoItems[index];
            print("렌더링 중인 일정: ${todo.title}");
            return Dismissible(
              key: Key(todo.userId ?? ''),
              onDismissed: (direction) {
                onDelete(todo);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title} 삭제됨')),
                );
              },
              background: Container(color: AppColors.deepYellow),
              child: ListTile(
                leading: CustomCircleIcon(
                  color: todo.iconColor,
                ),
                title: Text(todo.title),
                subtitle: Text(todo.description),
              ),
            );
          },
        ),
      );
    } catch (e) {
      print("TodoList 렌더링 중 오류 발생: $e");
      return Center(child: Text("일정을 불러오는 중 오류가 발생했습니다."));
    }
  }
}