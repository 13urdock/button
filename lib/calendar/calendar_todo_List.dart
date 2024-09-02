import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/custom_circle_icon.dart';
import '../src/color.dart';
import 'calendar_add_todo.dart';

class TodoList extends StatefulWidget {
  final List<TodoItem> todoItems;
  final Function(TodoItem) onDelete;

  TodoList({required this.todoItems, required this.onDelete});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Set<String> selectedItems = {};

  void toggleSelection(String userId) {
    setState(() {
      if (selectedItems.contains(userId)) {
        selectedItems.remove(userId);
      } else {
        selectedItems.add(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("TodoList: 총 ${widget.todoItems.length}개의 일정이 있습니다.");

    if (widget.todoItems.isEmpty) {
      return Center(child: Text("일정이 없습니다."));
    }

    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: widget.todoItems.length,
        itemBuilder: (context, index) {
          final todo = widget.todoItems[index];
          bool isdone = false;
          print("렌더링 중인 일정: ${todo.title}");
          return Dismissible(
            key: Key(todo.userId ?? ''),
            onDismissed: (direction) {
              widget.onDelete(todo);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todo.title} 삭제됨')),
              );
            },
            background: Container(color: AppColors.deepYellow),
            child: ListTile(
              leading: GestureDetector(
                onTap: (){
                  setState(() {
                    isdone = !isdone;
                  });
                },
                child: CustomCircleIcon(
                  color: todo.iconColor,
                  isSelected: isdone,
                ),
              ),
              title: Text(todo.title),
              subtitle: Text(todo.description),
              onTap: () {
                // AddTodo 위젯으로 네비게이션
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTodo()),
                );
              },
            ),
          );
        },
      );
    } catch (e) {
      print("TodoList 렌더링 중 오류 발생: $e");
      return Center(child: Text("일정을 불러오는 중 오류가 발생했습니다."));
    }
  }
}